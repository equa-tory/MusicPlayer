//
//  PlaylistView.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    // ======================================================

    var body: some View {
        ZStack {
            /// BG
            RoundedRectangle(cornerRadius: 64)
                .fill(.gray)
            
            List {
                ForEach(viewModel.currentPlaylist?.songs ?? []) { song in
                    Button(action: {}) {
                        Text(song.name)
                            .font(.title)
                        Text(song.artist)
                            .font(.subheadline)
                    }
                    .listRowBackground(Color.black)
                }
            }
            .scrollContentBackground(.hidden)
//            VStack{
//                ForEach(viewModel.currentPlaylist?.songs ?? []) { song in
//                    Text(song.name)
//                }
//            }
        }
        .ignoresSafeArea()
        .navigationTitle(viewModel.currentPlaylist?.name ?? "")
    }
}
