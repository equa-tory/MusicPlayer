//
//  MainView.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = PlaylistViewModel()
    @StateObject private var player = AudioPlayer()
    @ObservedObject private var library = Library()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
    private let aColor = UIColor(named: "ColorScheme")
    
    @State private var creatingPlaylist: Bool = false
    @State private var newPlaylistName: String = ""
    
    @Namespace private var anim
    
    // ======================================================
    
    init() {
        // create music folder
        if !FileManager.default.fileExists(atPath: DocumentMusicFolder.absoluteString) {
            try! FileManager.default.createDirectory(at: DocumentMusicFolder, withIntermediateDirectories: true, attributes: nil)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                let columns = Array(repeating: GridItem(.flexible(), spacing: -64), count: 2)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        PlaylistItemView(playlist: Playlist(name:"All", songs: library.songs), viewModel: viewModel, anim: anim)
                        ForEach(viewModel.playlists) { playlist in
                            PlaylistItemView(playlist: playlist, viewModel: viewModel, anim: anim)
                        }
                    }
                }
                .toolbar {
                    AddView(viewModel: viewModel, creatingPlaylist: $creatingPlaylist, newPlaylistName: $newPlaylistName, library: library)
                }
                .tint(colorScheme == .dark ? .white : .black)
                /// Alt playlist view
                //          }  .sheet(item: $viewModel.currentPlaylist) { playlist in
                //                PlaylistView(playlist: playlist, viewModel: viewModel)
                //            }
                
                /// Background tint
                BackgroundTint(viewModel: viewModel)
                
                VStack {
                    /// Playlist View
                    if let pl = viewModel.currentPlaylist {
                        PlaylistView(playlist: pl, anim: anim, player: player)
                            .opacity(viewModel.currentPlaylist == nil ? 0 : 1)
                            .padding()
                    }
                    else { Spacer() }
                    
                    /// Contorl Panel: REDO
                    ControlPanel()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
