import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bunny_video_player_platform_interface.dart';

/// An implementation of [FlutterBunnyVideoPlayerPlatform] that uses method channels.
class MethodChannelFlutterBunnyVideoPlayer extends FlutterBunnyVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bunny_video_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
