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
    
    @State var importingMusic: Bool = false
    
    @ObservedObject var library: Library
    
    // ======================================================

    var body: some View {
        Button(action: {
            if viewModel.currentPlaylist == nil {
                creatingPlaylist = true
            }
            else {
                // https://stackoverflow.com/questions/69613669/swiftui-fileimporter-cannot-show-again-after-dismissing-by-swipe-down
                if importingMusic {
                    // NOTE: Fixes broken fileimporter sheet not resetting on swipedown
                    importingMusic = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        importingMusic = true
                    }
                } else {
                    importingMusic = true
                }
                
                /// Debug
                /// {
                //                viewModel.currentPlaylist?.songs.append(Song(filePath: URL.downloadsDirectory.appendingPathComponent("test.mp3"), name:"Test",artist: "Unk"))
                /// }
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
        .fileImporter(isPresented: $importingMusic,
                        allowedContentTypes: [.audio], allowsMultipleSelection:true) { result in
              do {
                  let fileUrl = try result.get()
                  for url in fileUrl {
//                      viewModel.ImportUserSongFromFilesApp(url: url)
                      library.ImportUserSongFromFilesApp(url: url)
                  }
                  importingMusic = false
              } catch {
                  print("[ERR] Importing music: \(error.localizedDescription)")
              }
            importingMusic = false
          }
    }
}
