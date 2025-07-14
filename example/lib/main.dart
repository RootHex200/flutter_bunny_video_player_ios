import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bunny_video_player/flutter_bunny_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child:  SizedBox(
            child: BunnyPlayerView(
  accessKey: null,
  videoId: "eb1c4f77-0cda-46be-b47d-1118ad7c2ffe",
  libraryId: 759,
  playIconAsset: "assets/images/play.png",// Flutter asset path
),
          ),
        ),
      ),
    );
  }
}