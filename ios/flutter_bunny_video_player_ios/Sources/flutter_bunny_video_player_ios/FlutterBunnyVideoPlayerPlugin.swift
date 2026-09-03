import Flutter
import UIKit
import BunnyStreamPlayer
public class FlutterBunnyVideoPlayerPlugin: NSObject, FlutterPlugin {
  /// Held for the plugin's lifetime: downloads outlive any player view, so a
  /// handler tied to a view would stop reporting when the student navigates
  /// away from the lesson.
  private static var downloadHandler: BunnyDownloadChannelHandler?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_bunny_video_player_ios", binaryMessenger: registrar.messenger())
    let instance = FlutterBunnyVideoPlayerPlugin()

    let factory = BunnyPlayerPlatformViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "bunny_player_view_ios")
    registrar.addMethodCallDelegate(instance, channel: channel)

    registerDownloadChannels(with: registrar)
  }

  private static func registerDownloadChannels(with registrar: FlutterPluginRegistrar) {
    let handler = BunnyDownloadChannelHandler()
    downloadHandler = handler

    let methodChannel = FlutterMethodChannel(
      name: BunnyDownloadChannelHandler.methodChannelName,
      binaryMessenger: registrar.messenger()
    )
    methodChannel.setMethodCallHandler { call, result in
      handler.handle(call, result: result)
    }

    let eventChannel = FlutterEventChannel(
      name: BunnyDownloadChannelHandler.eventChannelName,
      binaryMessenger: registrar.messenger()
    )
    eventChannel.setStreamHandler(handler)
  }
}


