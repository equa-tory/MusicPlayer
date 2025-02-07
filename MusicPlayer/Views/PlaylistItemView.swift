//
//  PlaylistItem.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct PlaylistItemView: View {
    var playlist: Playlist
    @ObservedObject var viewModel: PlaylistViewModel
    let anim: Namespace.ID
    
    @State var isRenaming: Bool = false
    @State var newPlaylistName: String = ""
    @State var playlistToRename: Playlist?
    
    // ======================================================
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 32)
                .fill(.gray)
                .shadow(radius: 5, x: 5, y: 5)
                .matchedGeometryEffect(id: playlist.id, in: anim)
                .frame(width:150, height:150)
            
            Text(playlist.name)
                .font(.title)
//                .matchedGeometryEffect(id: <#T##Hashable#>, in: <#T##Namespace.ID#>)
        }
        .contextMenu {
            Button("Rename") {
                playlistToRename = playlist
                newPlaylistName = playlist.name
                isRenaming = true
            }
            Button("Delete", role: .destructive) {
                if let index = viewModel.playlists.firstIndex(of: playlist){
                    viewModel.playlists.remove(at: index)
                    viewModel.savePlaylists()
                }
            }
        }
        .alert("Rename Playlist", isPresented: $isRenaming, actions: {
            TextField("New Name", text: $newPlaylistName)
            Button("Save", action: {
                if let playlistToRename = playlistToRename {
                    playlistToRename.name = newPlaylistName
                    viewModel.savePlaylists()
                }
                isRenaming = false
            })
            Button("Cancel", role: .cancel) { }
        })
        .onTapGesture {
            withAnimation(.spring()) {
                viewModel.currentPlaylist = playlist
            }
        }
    }
}
