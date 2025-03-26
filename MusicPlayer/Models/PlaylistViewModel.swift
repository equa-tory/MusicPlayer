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

    private let storageKey = "playlists"
    
    @State private var pickerDelegate: PickerDelegate?
    @State private var currentTrack: URL?
    @State private var audioPlayer: AVAudioPlayer?
    
    // ======================================================
    
    /// Song duration
    //    func duration(for path: URL) -> Double {
    //        let asset = AVURLAsset(url: path)
    //        return Double(CMTimeGetSeconds(asset.duration))
    //    }
    
    
    
    func playMusic(file: URL) {
        if file.startAccessingSecurityScopedResource() {
            defer { file.stopAccessingSecurityScopedResource() }
            do {
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: file)
//                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                currentTrack = file
            } catch {
                print("Error playing file: \(error.localizedDescription)")
            }
        } else {
            print("Could not access the file.")
        }
    }
    
//    func addMusic(){
//        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
//        picker.allowsMultipleSelection = true
//        
//        // Assign the delegate and handle picked URLs
//        let delegate = PickerDelegate { urls in
//            for url in urls {
//                
//                let tmp = Song(
//                    name: url.lastPathComponent,
//                    artist: "Unk",
//                    filePath: url
//                )
//                if let index = self.playlists.firstIndex(where: { $0.id == self.currentPlaylist!.id }) {
//                    self.playlists[index].songs.append(tmp)
//                    self.savePlaylists()
//                }
//            }
//        }
//        picker.delegate = delegate
//        pickerDelegate = delegate // Keep a strong reference to the delegate
//
//        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
//    }
    
    func addMusic(){
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.allowsMultipleSelection = true
        
        // Assign the delegate and handle picked URLs
        let delegate = PickerDelegate { urls in
            for url in urls {
                
                let tmp = Song(
                    name: url.lastPathComponent,
                    artist: "Unk",
                    filePath: url
                )
                if let index = self.playlists.firstIndex(where: { $0.id == self.currentPlaylist?.id }) {
                    self.playlists[index].songs.append(tmp)
                    self.savePlaylists()
                }
            }
        }
        picker.delegate = delegate
        pickerDelegate = delegate // Keep a strong reference to the delegate

        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
    
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
    
//    func addSong(_ song: Song, to playlist: Playlist) {
//        if let index = playlists.firstIndex(of: playlist) {
//            playlists[index].songs.append(song)
//            savePlaylists()
//            playlists = playlists
//        }
//    }

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
