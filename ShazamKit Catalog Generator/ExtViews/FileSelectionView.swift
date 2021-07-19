//
//  FileSelectionView.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import SwiftUI

// File selection window
struct FileSelection: View {
    @ObservedObject var globalData: GlobalData
    
    var body: some View {
        VStack {
            fileSelectionFiles
            fileSelectionButtons
        }
    }
    
    // Selection table
    @State var selection = Set<File.ID>()
    var fileSelectionFiles: some View {
        Table(globalData.files, selection: $selection) {
            TableColumn("Name", value: \.name)
            TableColumn("File Type", value: \.type)
            TableColumn("Duration", value: \.duration)
            TableColumn("Full Path", value: \.path)
        }
        .onDeleteCommand { removeSelection() }
    }
    
    // HStack of buttons for adding, removing and generating.
    var fileSelectionButtons: some View {
        HStack {
            // Add files
            Button {
                globalData.files.append(contentsOf: globalData.fileManager.selectFiles(allowedTypes: [.audio]) ?? globalData.files)
            } label: {
                Image(systemName: "doc.fill.badge.plus")
            }
            
            // Remove files
            Button {
                removeSelection()
            } label: {
                Image(systemName: "minus")
            }
            
            Spacer()
            
            // Generate catalog
            Button {
                generateCatalog()
            } label: {
                Text("Generate Catalog")
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    // Remove selected files
    func removeSelection() {
        for id in selection {
            if let i = globalData.files.firstIndex(where: { id == $0.id }) {
                globalData.files.remove(at: i)
            }
        }
    }
    
    // Generate Catalog
    func generateCatalog() {
        globalData.generating = true
        
        DispatchQueue.main.async {
            let (c, s) = globalData.shazamManager.catalog(from: globalData.files) { globalData.progress = $0 }
            
            globalData.catalog = c
            globalData.signatures = s
            globalData.generating = false
            globalData.catalogGenerated = true
            globalData.progress = 0
        }
    }
}
