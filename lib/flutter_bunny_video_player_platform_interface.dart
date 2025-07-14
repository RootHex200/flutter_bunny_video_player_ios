import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bunny_video_player_method_channel.dart';

abstract class FlutterBunnyVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a FlutterBunnyVideoPlayerPlatform.
  FlutterBunnyVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBunnyVideoPlayerPlatform _instance = MethodChannelFlutterBunnyVideoPlayer();

  /// The default instance of [FlutterBunnyVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBunnyVideoPlayer].
  static FlutterBunnyVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBunnyVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(FlutterBunnyVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
