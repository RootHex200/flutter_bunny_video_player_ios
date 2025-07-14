//
//  BunnyPlayerViewController.swift
//  Runner
//
//  Created by Roothex200 on 7/9/25.
//

import Foundation
import SwiftUI
import UIKit
import BunnyStreamPlayer
class BunnyPlayerViewController: UIViewController {
    let accessKey: String?
    let videoId: String
    let libraryId: Int
    let playIconAsset: String

    init(accessKey: String?, videoId: String, libraryId: Int,playIconAsset: String) {
        self.accessKey = accessKey
        self.videoId = videoId
        self.libraryId = libraryId
        self.playIconAsset = playIconAsset
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
            playerIcons: icons
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

