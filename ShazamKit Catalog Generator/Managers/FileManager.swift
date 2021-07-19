//
//  ShazamManager.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

class FileManager {
    func selectFiles(allowedTypes: [UTType]) -> [File]? {
        let dialog = NSOpenPanel();
        dialog.showsResizeIndicator = true
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = false
        dialog.allowedContentTypes = allowedTypes

        guard (dialog.runModal() == .OK) else { return nil }
        
        var files = [File]()
        let results = dialog.urls
        
        for result in results {
            if let asset = try? AVAudioFile(forReading: result) {
                let duration = Double(asset.length) / asset.processingFormat.sampleRate
                let (mins, secs) = duration.toMinsSecs()
                let minStr = "\(mins < 10 ? "0" : "")\(mins)"
                let secStr = "\(secs < 10 ? "0" : "")\(secs)"
                
                let file = File(
                    asset: asset,
                    name: NSString(string: result.path).lastPathComponent
                        .replacingOccurrences(of: ".\(result.pathExtension)", with: ""),
                    type: result.pathExtension,
                    duration: "\(minStr):\(secStr)",
                    path: result.path,
                    url: result
                )
                
                files.append(file)
            }
        }
        
        return files
    }
    
    func selectDirectory(savingCatalog: Bool) -> URL? {
        if savingCatalog {
            let dialog = NSSavePanel()
            dialog.showsResizeIndicator = true
            dialog.nameFieldStringValue = "catalog.shazamcatalog"
            dialog.canCreateDirectories = true
            
            guard (dialog.runModal() == .OK) else { return nil }
            return dialog.url
        } else {
            let dialog = NSOpenPanel()
            dialog.canChooseDirectories = true
            dialog.canChooseFiles = false
            dialog.prompt = "Save"
            
            guard (dialog.runModal() == .OK) else { return nil }
            return dialog.url
        }
    }
}
