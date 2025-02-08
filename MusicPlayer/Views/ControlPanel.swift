//
//  ControlPanel.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import SwiftUI

struct ControlPanel: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(.gray)
            .shadow(radius: 8, x: 15, y: 15)
            .frame(height: 90)
            .padding(.horizontal)
    }
}
