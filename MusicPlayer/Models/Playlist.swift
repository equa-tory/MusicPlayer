//
//  Playlist.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation

struct Playlist: Identifiable, Codable {
    let id = UUID()
    var name: String
    var songs: [Song]
}
