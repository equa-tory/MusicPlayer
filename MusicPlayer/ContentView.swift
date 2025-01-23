//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 22.01.2025.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        PlaylistView()
    }
}

// ======================================================

// Playlist Model
class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []

    private let storageKey = "playlists"

    init() {
        loadPlaylists()
    }

    func addPlaylist(name: String) {
        let newPlaylist = Playlist(name: name, songs: [])
        playlists.append(newPlaylist)
        savePlaylists()
    }
    
    // === Saving ===

    public func savePlaylists() {
        if let data = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadPlaylists() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedPlaylists = try? JSONDecoder().decode([Playlist].self, from: data) {
            playlists = savedPlaylists
        }
    }
}

// Home View
struct PlaylistView: View {
    @StateObject private var viewModel = PlaylistViewModel()
    @State private var newPlaylistName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                List{
                    ForEach(viewModel.playlists) { playlist in
                        NavigationLink(destination: PlaylistDetailView(playlist: playlist, viewModel: viewModel)) {
                            Text(playlist.name)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                deletePlaylist(playlist)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove(perform: movePlaylist)
                }
                TextField("New Playlist Name", text: $newPlaylistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    if !newPlaylistName.isEmpty {
                        viewModel.addPlaylist(name: newPlaylistName)
                        newPlaylistName = ""
                    }
                }) {
                    Text("Add Playlist")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Playlists")
        }
    }
    
    private func deletePlaylist(_ playlist: Playlist) {
        if let index = viewModel.playlists.firstIndex(where: { $0.id == playlist.id }) {
            viewModel.playlists.remove(at: index)
            viewModel.savePlaylists()
        }
    }
    
    private func movePlaylist(from source: IndexSet, to destination: Int) {
        viewModel.playlists.move(fromOffsets: source, toOffset: destination)
        viewModel.savePlaylists()
    }
}

// Playlist View
struct PlaylistDetailView: View {
    // References
    let playlist: Playlist
    @ObservedObject var viewModel: PlaylistViewModel
    
    // Audio Player
    @ObservedObject private var musicManager = MusicManager()
    @State private var pickerDelegate: PickerDelegate? // Delegate reference
    @State private var currentTrack: URL?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            List(playlist.songs, id: \.id) { song in
                Button(action: {
//                    print("path: ",song.filePath)
                    playMusic(file: song.filePath)
                }) {
                    Text(song.title)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        removeSong(song: song)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle(playlist.name)
        
        Button("Add Music File") {
//            musicManager.addMusic(to: playlist, model: viewModel)
            addMusic()
        
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
//        .bottomSheet(isPresented: $isBottomSheetPresented) {
//            PlaybackControls(player: $player)
//        }
    }
    
    // Move to MusicManager
    private func addMusic(){
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.allowsMultipleSelection = true
        
        // Assign the delegate and handle picked URLs
        let delegate = PickerDelegate { urls in
            for url in urls {
                
                let tmp = Song(
                    title: url.lastPathComponent,
                    artist: "Unk",
                    filePath: url
                )
                if let index = viewModel.playlists.firstIndex(where: { $0.id == playlist.id }) {
                    viewModel.playlists[index].songs.append(tmp)
                    viewModel.savePlaylists()
                }
            }
        }
        picker.delegate = delegate
        pickerDelegate = delegate // Keep a strong reference to the delegate

        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
    
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
    
    private func removeSong(song: Song) {
        if let index = playlist.songs.firstIndex(where: { $0.id == song.id }) {
            if let playlistIndex = viewModel.playlists.firstIndex(where: { $0.id == playlist.id }) {
                viewModel.playlists[playlistIndex].songs.remove(at: index)
                viewModel.savePlaylists()
            }
        }
    }
    
    private func moveSong(from source: IndexSet, to destination: Int) {
        guard let sourceIndex = source.first else { return }
        guard destination >= 0 && destination < playlist.songs.count else { return }
        
        viewModel.playlists.indices.forEach { index in
            if viewModel.playlists[index].id == playlist.id {
                let item = viewModel.playlists[index].songs.remove(at: sourceIndex)
                viewModel.playlists[index].songs.insert(item, at: destination)
                viewModel.savePlaylists()
            }
        }
    }
}

// ======================================================

#Preview {
    ContentView()
}
