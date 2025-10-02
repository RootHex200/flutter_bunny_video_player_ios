// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_bunny_video_player_ios",
    platforms: [
        .iOS("15.6")
    ],
    products: [
        .library(name: "flutter-bunny-video-player-ios", targets: ["flutter_bunny_video_player_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/RootHex200/bunny-stream-ios.git", branch: "remove-openapi")
        
    ],
    targets: [
        .target(
            name: "flutter_bunny_video_player_ios",
            dependencies: [
                .product(name: "BunnyStreamAPI", package: "bunny-stream-ios"),
                .product(name: "BunnyStreamPlayer", package: "bunny-stream-ios"),
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
