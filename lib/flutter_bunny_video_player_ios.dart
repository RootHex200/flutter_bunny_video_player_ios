import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BunnyPlayerController {
  MethodChannel? _channel;
  bool _disposed = false;

  bool get isDisposed => _disposed;

  void _attach(int viewId) {
    _channel = MethodChannel('flutter_bunny_video_player_ios_$viewId');
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    try {
      await _channel?.invokeMethod('dispose');
    } catch (_) {
      // Native side may already be torn down (widget disposed first); safe to ignore.
    }
    _channel = null;
  }
}

class BunnyIosPlayerView extends StatefulWidget {
  final BunnyPlayerController? controller;
  final String? accessKey;
  final String videoId;
  final int libraryId;
  final String? playIconAsset;
  final String? token;
  final int? expires;
  final String? referer;

  const BunnyIosPlayerView({
    super.key,
    this.controller,
    required this.accessKey,
    required this.videoId,
    required this.libraryId,
    this.playIconAsset,
    this.token,
    this.expires,
    this.referer,
  });

  @override
  State<BunnyIosPlayerView> createState() => _BunnyPlayerViewState();
}

class _BunnyPlayerViewState extends State<BunnyIosPlayerView> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'bunny_player_view_ios';

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        onPlatformViewCreated: (int id) {
          widget.controller?._attach(id);
        },
        creationParams: {
          'accessKey': widget.accessKey,
          'videoId': widget.videoId,
          'libraryId': widget.libraryId,
          'playIconAsset': widget.playIconAsset,
          'token': widget.token,
          'expires': widget.expires,
          'referer': widget.referer,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Container();
  }
}
