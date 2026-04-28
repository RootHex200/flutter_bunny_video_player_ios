import 'package:flutter/material.dart';
import 'package:flutter_bunny_video_player_ios/flutter_bunny_video_player_ios.dart';

void main() => runApp(const MyApp());

const _videoId = "f7c26615-d11e-451c-9eae-3c97606b2fca";
const _libraryId = 316762;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Holding null means the player is not in the tree — disposed.
  BunnyPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = BunnyPlayerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _stopVideo() async {
    final c = _controller;
    if (c == null) return;
    await c.dispose();
    setState(() => _controller = null);
  }

  void _restartVideo() {
    setState(() => _controller = BunnyPlayerController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Bunny player example')),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: controller == null
                ? const ColoredBox(
                    color: Color(0xFF111111),
                    child: Center(
                      child: Text(
                        'Video disposed',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                : BunnyIosPlayerView(
                    key: ValueKey(controller),
                    controller: controller,
                    accessKey: null,
                    videoId: _videoId,
                    libraryId: _libraryId,
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: controller == null ? null : _stopVideo,
                child: const Text('Stop & dispose'),
              ),
              ElevatedButton(
                onPressed: controller == null ? _restartVideo : null,
                child: const Text('Restart video'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SecondPage()),
                  );
                },
                child: const Text('Open second screen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late final BunnyPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BunnyPlayerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second screen')),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: BunnyIosPlayerView(
              controller: _controller,
              accessKey: null,
              videoId: _videoId,
              libraryId: _libraryId,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
