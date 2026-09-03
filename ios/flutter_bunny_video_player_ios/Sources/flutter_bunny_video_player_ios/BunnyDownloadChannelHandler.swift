import Combine
import Flutter
import Foundation
import BunnyStreamPlayer

/// Bridges the offline download API onto Flutter.
///
/// Channel names, method names, payload keys and error codes here are a
/// contract shared byte-for-byte with the Android plugin. The host app is one
/// Dart implementation over both; if the two drift, that single implementation
/// silently becomes two.
///
/// Registered against the plugin rather than a platform view because downloads
/// outlive any player: a per-view channel would stop reporting the moment the
/// student navigated away from the lesson.
public class BunnyDownloadChannelHandler: NSObject, FlutterStreamHandler {

  public static let methodChannelName = "klasio/bunny_video_downloads"
  public static let eventChannelName = "klasio/bunny_video_downloads/events"

  private let manager = BunnyOfflineManager.shared
  private var eventSink: FlutterEventSink?
  private var cancellable: AnyCancellable?

  // MARK: - Method channel

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      start(call, result: result)
    case "cancel":
      withCacheKey(call, result) { key in
        self.manager.cancelDownload(cacheKey: key)
        result(nil)
      }
    case "delete":
      withCacheKey(call, result) { key in
        self.manager.deleteVideo(cacheKey: key)
        result(nil)
      }
    case "deleteAll":
      manager.clearAllDownloads()
      result(nil)
    case "list":
      result(manager.getAllDownloadedVideos().map(Self.entryMap))
    case "get":
      withCacheKey(call, result) { key in
        guard let video = self.manager.getVideoInfo(cacheKey: key) else {
          result(nil)
          return
        }
        result(Self.entryMap(video))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func start(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let cacheKey = args["cacheKey"] as? String, !cacheKey.isEmpty,
      let videoId = args["videoId"] as? String, !videoId.isEmpty,
      let libraryId = (args["libraryId"] as? NSNumber)?.intValue
    else {
      result(
        FlutterError(
          code: "not_found",
          message: "cacheKey, videoId and libraryId are required",
          details: nil
        )
      )
      return
    }

    manager.downloadVideo(
      cacheKey: cacheKey,
      videoId: videoId,
      libraryId: libraryId,
      token: args["token"] as? String,
      expires: (args["expires"] as? NSNumber)?.intValue,
      referer: args["referer"] as? String,
      title: args["title"] as? String,
      wifiOnly: (args["wifiOnly"] as? Bool) ?? true
    ) { accepted, error in
      if accepted {
        result(nil)
      } else {
        result(
          FlutterError(
            code: Self.errorCode(for: error),
            message: error?.localizedDescription ?? "Download could not be started",
            details: nil
          )
        )
      }
    }
  }

  private func withCacheKey(
    _ call: FlutterMethodCall,
    _ result: @escaping FlutterResult,
    _ body: (String) -> Void
  ) {
    guard
      let args = call.arguments as? [String: Any],
      let cacheKey = args["cacheKey"] as? String, !cacheKey.isEmpty
    else {
      result(
        FlutterError(code: "not_found", message: "cacheKey is required", details: nil)
      )
      return
    }
    body(cacheKey)
  }

  // MARK: - Event channel

  public func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    cancellable = manager.downloadProgressPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] progress in
        self?.eventSink?(Self.progressMap(progress))
      }
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    cancellable?.cancel()
    cancellable = nil
    eventSink = nil
    return nil
  }

  // MARK: - Wire mapping

  private static func entryMap(_ video: OfflineVideo) -> [String: Any] {
    ["cacheKey": video.cacheKey, "sizeBytes": video.fileSize]
  }

  private static func progressMap(_ progress: DownloadProgress) -> [String: Any] {
    [
      "cacheKey": progress.cacheKey,
      "status": statusName(progress.status),
      "progress": progress.progress,
      "sizeBytes": progress.downloadedSize,
      "errorCode": errorCode(for: progress.error),
    ]
  }

  private static func statusName(_ status: DownloadStatus) -> String {
    switch status {
    case .notStarted, .paused: return "queued"
    case .downloading: return "downloading"
    case .completed: return "downloaded"
    case .failed: return "failed"
    case .cancelled: return "cancelled"
    }
  }

  /// Maps a native error onto the coarse codes the Android side emits for the
  /// same conditions. "Your storage is full" and "check your connection" call
  /// for different responses, so collapsing both into a generic failure would
  /// be a regression in the host app's usefulness.
  private static func errorCode(for error: Error?) -> String {
    guard let error = error else { return "unknown" }

    let nsError = error as NSError
    if nsError.domain == NSURLErrorDomain {
      switch nsError.code {
      case NSURLErrorNotConnectedToInternet,
        NSURLErrorNetworkConnectionLost,
        NSURLErrorTimedOut,
        NSURLErrorCannotFindHost,
        NSURLErrorCannotConnectToHost:
        return "network"
      case NSURLErrorUserAuthenticationRequired, NSURLErrorNoPermissionsToReadFile:
        return "unauthorized"
      case NSURLErrorFileDoesNotExist, NSURLErrorBadURL:
        return "not_found"
      default:
        break
      }
    }

    if nsError.domain == NSCocoaErrorDomain, nsError.code == NSFileWriteOutOfSpaceError {
      return "storage_full"
    }

    let description = error.localizedDescription.lowercased()
    if description.contains("space") { return "storage_full" }
    if description.contains("unauthor") || description.contains("403") {
      return "unauthorized"
    }
    if description.contains("not found") || description.contains("404") {
      return "not_found"
    }
    return "unknown"
  }
}
