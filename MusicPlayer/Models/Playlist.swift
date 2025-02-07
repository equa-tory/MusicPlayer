//
//  Playlist.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation

class Playlist: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var songs: [Song]
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(name: String, songs: [Song] = []) {
        self.name = name
        self.songs = songs
    }
}
