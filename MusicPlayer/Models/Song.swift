//
//  Song.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation

struct Song: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var artist: String
    var filePath: URL
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id
    }
}
