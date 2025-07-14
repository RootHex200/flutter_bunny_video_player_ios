

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BunnyPlayerView extends StatefulWidget {
  final String? accessKey;
  final String videoId;
  final int libraryId;
  final String? playIconAsset;

  const BunnyPlayerView({
    super.key,
    required this.accessKey,
    required this.videoId,
    required this.libraryId,
    this.playIconAsset,
  });

  @override
  State<BunnyPlayerView> createState() => _BunnyPlayerViewState();
}

class _BunnyPlayerViewState extends State<BunnyPlayerView> {

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
    const viewType = 'bunny_player_view';

    if(Platform.isIOS){
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {
        'accessKey': widget.accessKey,
        'videoId': widget.videoId,
        'libraryId': widget.libraryId,
        'playIconAsset': widget.playIconAsset,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
    }
    return Container();
  }
}

