//
//  Song.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation

struct Song: Identifiable, Codable {
    let id = UUID()
    let filePath: URL
    var title: String
    var artist: String
}
