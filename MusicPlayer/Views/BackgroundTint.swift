//
//  BackgroundTing.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct BackgroundTint: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    // ======================================================

    var body: some View {
        Color.black.opacity(viewModel.currentPlaylist == nil ? 0 : 0.5)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.spring()) {
                    viewModel.currentPlaylist = nil
                }
            }
    }
}
