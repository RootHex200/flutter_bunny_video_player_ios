//
//  BunnyPlayerViewController.swift
//  Runner
//
//  Created by Roothex200 on 7/9/25.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import BunnyStreamPlayer
import Flutter
class BunnyPlayerViewController: UIViewController {
    let accessKey: String?
    let videoId: String
    let libraryId: Int
    let playIconAsset: String
    let token: String?
    let expires: Int?
    let referer: String?
    private weak var avPlayer: AVPlayer?

    init(accessKey: String?, videoId: String, libraryId: Int,playIconAsset: String
         ,token:String?,expires:Int?,referer:String?) {
        self.accessKey = accessKey
        self.videoId = videoId
        self.libraryId = libraryId
        self.playIconAsset = playIconAsset
        self.token=token
        self.referer = referer
        self.expires=expires
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let iconImage = loadFlutterAsset(named: playIconAsset)
        let icons = PlayerIcons(play: iconImage)
        
        let playerView = BunnyFlutterPlayer(
            accessKey: accessKey,
            videoId: videoId,
            libraryId: libraryId,
            playerIcons: icons,
            token: token,
            expires: expires,
            referer: referer,
            onPlayerReady: { [weak self] player in
                NSLog("🎬 [BunnyPlayer] onPlayerReady — captured AVPlayer reference")
                self?.avPlayer = player
            }
        )

        let hostingController = UIHostingController(rootView: playerView)
        addChild(hostingController)
        // Auto layout to match Flutter size
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
       // hostingController.didMove(toParent: self)
    }

    func cleanup() {
        NSLog("🧹 [BunnyPlayer] cleanup() called — videoId: %@, children: %d", videoId, children.count)
        if let player = avPlayer {
            NSLog("🧹 [BunnyPlayer] tearing down AVPlayer directly (pause + replaceCurrentItem nil)")
            player.pause()
            player.replaceCurrentItem(with: nil)
        } else {
            NSLog("🧹 [BunnyPlayer] no captured AVPlayer — relying on SwiftUI onDisappear teardown")
        }
        avPlayer = nil
        children.forEach { child in
            NSLog("🧹 [BunnyPlayer] removing child: %@", String(describing: type(of: child)))
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        NSLog("🧹 [BunnyPlayer] cleanup() done")
    }

    deinit {
        NSLog("⚫️ [BunnyPlayer] BunnyPlayerViewController deinit — videoId: %@", videoId)
    }

    private func loadFlutterAsset(named asset: String) -> Image {
        let key = FlutterDartProject.lookupKey(forAsset: asset)
        if let path = Bundle.main.path(forResource: key, ofType: nil),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "play.fill")
        }
    }
}

