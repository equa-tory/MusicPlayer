//
//  PlaylistView.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct PlaylistView: View {
    var playlist: Playlist
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let anim: Namespace.ID

    let player: AudioPlayer
    
    // ======================================================

    var body: some View {
        ZStack {
            /// BG
            RoundedRectangle(cornerRadius: 32)
                .fill(.gray)
                .shadow(radius: 5, x: 5, y: 5)
                .matchedGeometryEffect(id: playlist.id, in: anim)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /// List like
//            List (playlist.songs, id: \.id) { song in
//                Button(action: {
//                    /// Play playlist starting of music id in currentPlaylist:
//                    
//                }) {
//                    Text(song.name)
//                        .font(.title)
//                    Text(song.artist)
//                        .font(.subheadline)
//                }
//                .listRowBackground(Color.clear)
//                .swipeActions{
//                    Button("Lol", systemImage: "trash"){
//                        print("Lol")
//                    }
//                }
//            }
//            .scrollContentBackground(.hidden)
            
            /// Grid Like
            /// Horizontal Spacing between items
            let columns = Array(repeating: GridItem(.flexible(), spacing: -32), count: 2)
            ScrollView {
                /// Vertical Spacing between items
                LazyVGrid(columns: columns, spacing: 0) {
                    
//                    ForEach(0..<21) {_ in
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 32)
//                                .fill(.gray)
//                                .shadow(radius: 5, x: 5, y: 5)
//                            
//                            VStack {
//                                Text("Walking with elephants")
//                                    .font(.title)
//                                
//                                Text("1:30")
//                                    .font(.subheadline)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                        }
//                        .padding(.top, 16) /// Vertical padding in items
//                        .frame(width:150, height:166)
//                    }
                    
                    ForEach(playlist.songs) { song in
                        ZStack{
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.gray)
                                .shadow(radius: 5, x: 5, y: 5)
                            
                            VStack {
                                Text(song.name)
                                    .font(.title)
                                
//                                Text(String(Duration(song.filePath)))
//                                    .font(.subheadline)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        .padding(.top, 16) /// Vertical padding in items
                        .frame(width:150, height:166)
                        .onTapGesture {
                            player.prepareAndStartPlayingAudio(url: song.filePath)
                        }
                        
                    }
                    
                }
            }
        }
        .navigationTitle(playlist.name)
    }
}
