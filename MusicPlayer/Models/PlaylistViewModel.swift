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
    @Published var playlists: [Playlist] = []
    @Published var currentPlaylist: Playlist?
    @Published var audioPlayer: AVAudioPlayer?
    @State private var pickerDelegate: PickerDelegate?

    private let storageKey = "playlists"
    
    // ======================================================
    
//    func ImportUserSongFromFilesApp(url: URL) {
//        let songFileName = url.lastPathComponent
//        let songName = url.deletingPathExtension().lastPathComponent
//        let songPath = DocumentMusicFolder.appendingPathComponent(songFileName)
//        if ImportFileFromFilesApp(url, to: songPath) {
//            self.currentPlaylist!.songs.append(Song(name: songName, artist:"Unk", filePath: songPath))
//            self.savePlaylists()
//            self.currentPlaylist = self.currentPlaylist
//        }
//    }
    
    /// Song duration
    //    func duration(for path: URL) -> Double {
    //        let asset = AVURLAsset(url: path)
    //        return Double(CMTimeGetSeconds(asset.duration))
    //    }
    
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
            playlists = playlists
        }
    }

    func deleteSong(_ song: Song, from playlist: Playlist) {
        if let playlistIndex = playlists.firstIndex(of: playlist),
           let songIndex = playlists[playlistIndex].songs.firstIndex(of: song) {
            playlists[playlistIndex].songs.remove(at: songIndex)
            savePlaylists()
        }
    }

    /// Old Playing
//    func playMusic(_ file: URL) {
//        do {
//            audioPlayer?.stop()
//            audioPlayer = try AVAudioPlayer(contentsOf: file)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        } catch {
//            print("Error playing file: \(error.localizedDescription)")
//        }
//    }
    
}
