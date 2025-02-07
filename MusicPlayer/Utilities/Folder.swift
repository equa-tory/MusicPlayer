//
//  Folder.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 06.02.2025.
//

import Foundation

let DocumentFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let DocumentMusicFolder = DocumentFolder.appendingPathComponent("Music")

func ImportFileFromFilesApp(_ filePathInFiles: URL, to filePathInSandbox: URL) -> Bool {

    do {
        if FileManager.default.fileExists(atPath: filePathInSandbox.path) {
            return false
//            try FileManager.default.removeItem(at: filePathInSandbox)
        }

        let isSecurityScoped = filePathInFiles.startAccessingSecurityScopedResource()
        try FileManager.default.copyItem(atPath: filePathInFiles.path, toPath: filePathInSandbox.path)
        if isSecurityScoped {
            filePathInFiles.stopAccessingSecurityScopedResource()
        }
    } catch {
        print("Cannot copy file from \(filePathInFiles.path) to \(filePathInSandbox.path): \(error)")
    }
    return true
}
