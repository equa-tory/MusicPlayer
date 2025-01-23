//
//  Structs.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 18.01.2025.
//

import Foundation

struct Song: Identifiable, Codable {
    let id = UUID()
    let title: String
    let artist: String
    let filePath: URL
}

struct Playlist: Identifiable, Codable {
    let id = UUID()
    var name: String
    var songs: [Song]
    
//    init(name: String, songs: [Song]){
//        self.name = name
//        self.songs = songs
//    }
}
