# Flutter Bunny Video Player iOS

A Flutter plugin that provides a native iOS video player using Bunny Stream's video streaming service.

## Features

- 🎥 **Native iOS Video Player**: Built on top of Bunny Stream's iOS SDK
- 🔄 **Token-based Authentication**: Secure access control with expiration support

## Requirements

### Flutter Requirements
- Flutter SDK: `>=3.3.0`
- Dart SDK: `>=3.5.0`
- iOS Deployment Target: `15.6+`

### iOS Requirements
- **Swift Package Manager**: This plugin uses Swift Package Manager for iOS dependencies

## Installation

### 1. Add to pubspec.yaml

```yaml
dependencies:
  flutter_bunny_video_player_ios: ^0.0.1
```

### 2. Enable Swift Package Manager in Flutter

**IMPORTANT**: This plugin requires Swift Package Manager to be enabled in your Flutter project. Follow these steps:

#### For New Flutter Projects (Flutter 3.16+)
```bash
flutter create --platforms=ios my_app
cd my_app
flutter config --enable-swift-package-manager
```

#### For Existing Flutter Projects
1. **Enable Swift Package Manager globally**:
   ```bash
   flutter config --enable-swift-package-manager
   ```

2. **Update your iOS project**:
   ```bash
   cd ios
   rm -rf Pods Podfile.lock
   flutter clean
   flutter pub get
   cd ios
   pod install
   ```

3. **Verify Swift Package Manager is enabled**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Check that Swift Package Manager dependencies are visible in the project navigator
   - Ensure no CocoaPods-related build errors


## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bunny_video_player_ios/flutter_bunny_video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bunny Video Player')),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: BunnyIosPlayerView(
            accessKey: 'your-access-key', // Optional
            videoId: 'your-video-id',     // Required
            libraryId: 123456,            // Required
            token: 'your-token',          // Optional for DRM
            expires: 20250922120000,      // Optional token expiration
            playIconAsset: 'assets/play_icon.png', // Optional custom play icon
          ),
        ),
      ),
    );
  }
}
```