//
//  AddView.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    @Binding var creatingPlaylist: Bool
    @Binding var newPlaylistName: String
    
    // ======================================================

    var body: some View {
        Button(action: {
            if viewModel.currentPlaylist == nil {
                creatingPlaylist = true
            }
            else {
                viewModel.openPicker()
//                viewModel.currentPlaylist?.songs.append(Song(filePath: URL.downloadsDirectory.appendingPathComponent("test.mp3"), name:"Test",artist: "Unk"))
            }
        }) {
            Label("Add", systemImage: "plus")
        }
        .alert("New Playlist", isPresented: $creatingPlaylist, actions: {
            TextField("Playlist Name", text: $newPlaylistName)
            Button("Save", action: {
                let newPlaylist = Playlist(name: newPlaylistName, songs: [])
//                            viewModel.objectWillChange.send() // Force SwiftUI to detect changes
                viewModel.playlists.append(newPlaylist)
                viewModel.savePlaylists()
                newPlaylistName = ""
                
                creatingPlaylist = false
            })
            Button("Cancel", role: .cancel) { }
        })
    }
}
