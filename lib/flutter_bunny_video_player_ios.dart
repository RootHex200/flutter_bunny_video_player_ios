import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BunnyIosPlayerView extends StatefulWidget {
  final String? accessKey;
  final String videoId;
  final int libraryId;
  final String? playIconAsset;
  final String? token;
  final int? expires;

  const BunnyIosPlayerView({
    super.key,
    required this.accessKey,
    required this.videoId,
    required this.libraryId,
    this.playIconAsset,
    this.token,
    this.expires
  });

  @override
  State<BunnyIosPlayerView> createState() => _BunnyPlayerViewState();
}

class _BunnyPlayerViewState extends State<BunnyIosPlayerView> {
  @override
  void initState() {
// SystemChrome.setPreferredOrientations([
//   DeviceOrientation.portraitUp,
//   DeviceOrientation.portraitDown,
//   DeviceOrientation.landscapeLeft,
//   DeviceOrientation.landscapeRight,
// ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const viewType = 'bunny_player_view_ios';

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {
          'accessKey': widget.accessKey,
          'videoId': widget.videoId,
          'libraryId': widget.libraryId,
          'playIconAsset': widget.playIconAsset,
          'token':widget.token,
          'expires':widget.expires,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Container();
  }
}
