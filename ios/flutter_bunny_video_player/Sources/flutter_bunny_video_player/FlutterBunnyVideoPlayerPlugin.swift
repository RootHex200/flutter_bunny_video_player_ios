import Flutter
import UIKit
import BunnyStreamPlayer
public class FlutterBunnyVideoPlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_bunny_video_player", binaryMessenger: registrar.messenger())
    let instance = FlutterBunnyVideoPlayerPlugin()
      
    let factory = BunnyPlayerPlatformViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "bunny_player_view")
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

}


