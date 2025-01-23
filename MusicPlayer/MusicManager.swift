import SwiftUI
import AVFoundation

class MusicManager: NSObject, ObservableObject, UIDocumentPickerDelegate {
    @State private var currentTrack: URL?     // Currently playing track
    @State private var audioPlayer: AVAudioPlayer?
    @State private var pickerDelegate: PickerDelegate? // Delegate reference
    
    func addMusic(to playlist: Playlist, model: PlaylistViewModel) {
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
//                DispatchQueue.main.async {
//                    self.playlist?.songs.append(tmp) // Update playlist
//                }
//                playlist.songs.append(tmp)
                if let index = model.playlists.firstIndex(where: { $0.id == playlist.id }) {
                    model.playlists[index].songs.append(tmp)
                    model.savePlaylists()
                }
            }
        }
        
        picker.delegate = delegate
        pickerDelegate = delegate // Keep a strong reference to the delegate

        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }

    func playMusic(file: URL) {
        if file.startAccessingSecurityScopedResource() {
            defer { file.stopAccessingSecurityScopedResource() } // Ensure resource is released

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
}

class PickerDelegate: NSObject, UIDocumentPickerDelegate {
    private let onPicked: ([URL]) -> Void

    init(onPicked: @escaping ([URL]) -> Void) {
        self.onPicked = onPicked
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onPicked(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
}
