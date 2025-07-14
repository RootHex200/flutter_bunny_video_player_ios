import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bunny_video_player/flutter_bunny_video_player.dart';
import 'package:flutter_bunny_video_player/flutter_bunny_video_player_platform_interface.dart';
import 'package:flutter_bunny_video_player/flutter_bunny_video_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBunnyVideoPlayerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBunnyVideoPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBunnyVideoPlayerPlatform initialPlatform = FlutterBunnyVideoPlayerPlatform.instance;

  test('$MethodChannelFlutterBunnyVideoPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBunnyVideoPlayer>());
  });

  test('getPlatformVersion', () async {
    FlutterBunnyVideoPlayer flutterBunnyVideoPlayerPlugin = FlutterBunnyVideoPlayer();
    MockFlutterBunnyVideoPlayerPlatform fakePlatform = MockFlutterBunnyVideoPlayerPlatform();
    FlutterBunnyVideoPlayerPlatform.instance = fakePlatform;

    expect(await flutterBunnyVideoPlayerPlugin.getPlatformVersion(), '42');
  });
}
