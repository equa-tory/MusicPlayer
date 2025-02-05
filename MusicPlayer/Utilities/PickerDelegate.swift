//
//  PickerDelegate.swift
//  MusicPlayer
//
//  Created by Alex Barauskas on 05.02.2025.
//

import Foundation
import SwiftUI

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
