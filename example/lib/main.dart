import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DownloadsPage()),
                  );
                },
                child: const Text('Downloads'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Demonstrates offline downloads: start/cancel/delete plus live progress,
/// then playing the downloaded copy with `offline: true`.
class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  // Same key the download is started with; playback looks it up by this.
  static const _cacheKey = 'demo-$_videoId';

  StreamSubscription<BunnyDownloadEvent>? _subscription;
  BunnyDownloadEvent? _event;
  List<BunnyOfflineVideo> _completed = const [];
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _subscription = BunnyVideoDownloads.events().listen((e) {
      if (e.cacheKey != _cacheKey) return;
      setState(() => _event = e);
      if (e.status == BunnyDownloadStatus.downloaded) _refreshList();
    });
    _refreshList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshList() async {
    final videos = await BunnyVideoDownloads.list();
    if (mounted) setState(() => _completed = videos);
  }

  Future<void> _startDownload() async {
    try {
      await BunnyVideoDownloads.start(
        cacheKey: _cacheKey,
        videoId: _videoId,
        libraryId: _libraryId,
        wifiOnly: false,
      );
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('start failed: ${e.code} — ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = _event;
    final isDownloaded =
        _completed.any((v) => v.cacheKey == _cacheKey) ||
        event?.status == BunnyDownloadStatus.downloaded;
    final downloading = event?.status == BunnyDownloadStatus.downloading;

    return Scaffold(
      appBar: AppBar(title: const Text('Offline downloads')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'cacheKey: $_cacheKey',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${isDownloaded ? 'downloaded' : event?.status.name ?? 'idle'}',
          ),
          if (downloading) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (event?.progress ?? 0) >= 0 ? event?.progress : null,
            ),
            const SizedBox(height: 4),
            Text(
              '${((event?.progress ?? 0) * 100).toStringAsFixed(0)}% • '
              '${((event?.sizeBytes ?? 0) / 1024 / 1024).toStringAsFixed(1)} MB',
            ),
          ],
          if (event?.status == BunnyDownloadStatus.failed)
            Text('Error: ${event?.errorCode}'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: downloading ? null : _startDownload,
                child: const Text('Download'),
              ),
              ElevatedButton(
                onPressed:
                    downloading || event?.status == BunnyDownloadStatus.queued
                    ? () => BunnyVideoDownloads.cancel(_cacheKey)
                    : null,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isDownloaded
                    ? () async {
                        await BunnyVideoDownloads.delete(_cacheKey);
                        setState(() => _event = null);
                        _refreshList();
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isDownloaded) ...[
            SwitchListTile(
              title: const Text('Play offline copy'),
              subtitle: const Text(
                'Turn off Wi-Fi (Mac Wi-Fi for the simulator, Airplane Mode '
                'on a device) — the video should still play.',
              ),
              value: _offlineMode,
              onChanged: (v) => setState(() => _offlineMode = v),
            ),
            SizedBox(
              height: 220,
              child: BunnyIosPlayerView(
                // Platform views read creationParams only once, at creation;
                // the key forces a new native view when the toggle flips.
                key: ValueKey(_offlineMode),
                accessKey: null,
                videoId: _videoId,
                libraryId: _libraryId,
                cacheKey: _offlineMode ? _cacheKey : null,
                offline: _offlineMode,
              ),
            ),
          ],
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
