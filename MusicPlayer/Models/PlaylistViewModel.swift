//
//  PlaylistViewModel.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation
import SwiftUI
import AVFoundation

class PlaylistViewModel: ObservableObject {
//    @Published var customPlaylists: [Playlist] = []
    @Published var playlists: [Playlist] = []
    @Published var currentPlaylist: Playlist?
    @Published var audioPlayer: AVAudioPlayer?
    @State private var pickerDelegate: PickerDelegate?

    private let storageKey = "playlists"
    
    // ======================================================

    init() {
        loadPlaylists()
    }

    func savePlaylists() {
        if let data = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func loadPlaylists() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedPlaylists = try? JSONDecoder().decode([Playlist].self, from: data) {
            playlists = savedPlaylists
        }
    }

    func addSong(_ song: Song, to playlist: Playlist) {
        if let index = playlists.firstIndex(of: playlist) {
            playlists[index].songs.append(song)
            savePlaylists()
        }
    }

    func deleteSong(_ song: Song, from playlist: Playlist) {
        if let playlistIndex = playlists.firstIndex(of: playlist),
           let songIndex = playlists[playlistIndex].songs.firstIndex(of: song) {
            playlists[playlistIndex].songs.remove(at: songIndex)
            savePlaylists()
        }
    }

    func playMusic(_ file: URL) {
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: file)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing file: \(error.localizedDescription)")
        }
    }
    
    // ======================================================

    func openPicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.allowsMultipleSelection = true
        
        // Assign the delegate and handle picked URLs
        let delegate = PickerDelegate { urls in
            for url in urls {
                
                let song = Song(
                    filePath: url,
                    name: url.lastPathComponent,
                    artist: "Unk"
                )
//                self.objectWillChange.send() // Force SwiftUI to detect changes
//                self.currentPlaylist?.songs.append(song)
//                self.savePlaylists()
                
                self.addSong(song, to: self.currentPlaylist!)
            }
        }
        picker.delegate = delegate
        pickerDelegate = delegate // Keep a strong reference to the delegate
        
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
    
}
