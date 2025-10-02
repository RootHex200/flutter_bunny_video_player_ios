//
//  BunnyFlutterPlayer.swift
//  Runner
//
//  Created by Roothex200 on 7/10/25.
//

import Foundation
import SwiftUI
import BunnyStreamPlayer
struct BunnyFlutterPlayer: View {
    let accessKey: String?
    let videoId: String
    let libraryId: Int
    let playerIcons: PlayerIcons
    let token: String?
    let expires:Int?

    var body: some View {
        BunnyStreamPlayer(
            accessKey: accessKey,
                        videoId: videoId,
                        libraryId: libraryId,
                         token: token,
                        expires: expires)
    }
}
