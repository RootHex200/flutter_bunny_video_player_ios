import 'package:flutter/material.dart';
import 'package:flutter_bunny_video_player_ios/flutter_bunny_video_player_ios.dart';

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
        appBar: AppBar(title: const Text('Plugin example app')),
        body: const Center(
          child: SizedBox(
            child: BunnyIosPlayerView(
              accessKey: null,
              videoId: "b773d67d-8006-45d5-b22a-731262d61af9",
              libraryId: 267648,
              expires: 1759775322,
              token:
                  "e93cfad682e66356011a54526126eebff7ccd977fcbba7f2f892df3dd7a9f91d",
                  referer: "https://test.klasio.dev",
              // Flutter asset path
            ),
          ),
        ),
      ),
    );
  }
}
