//
//  GeneratedView.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import SwiftUI
import ShazamKit

struct GeneratedCatalogView: View {
    @ObservedObject var globalData: GlobalData
    @State var foundText = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    goBack()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                }
                
                Spacer()
            }
            .keyboardShortcut(.cancelAction)
            .padding()
            
            Spacer()
            
            Label {
                Text("Catalog generated")
            } icon: {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
            .font(.largeTitle)
            
            Spacer()
                
            Text(foundText)
                .padding(.vertical)
            
            HStack {
                Button {
                    testCatalog()
                } label: {
                    Label(globalData.matching ? "Testing..." : "Test catalog", systemImage: globalData.matching ? "mic.fill" : "mic")
                }
                
                Spacer()
                
                Button {
                    saveSignatures()
                } label: {
                    Label("Save signatures", systemImage: "square.and.arrow.down.on.square")
                }
                
                Button {
                    saveCatalog()
                } label: {
                    Label("Save catalog", systemImage: "square.and.arrow.down")
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
    }
    
    func testCatalog() {
        if !globalData.matching {
            globalData.shazamManager.startMatching(with: globalData.catalog) { foundText = "Found: \($0)" }
        } else {
            globalData.shazamManager.stopMatching()
            foundText = ""
        }
        
        globalData.matching.toggle()
    }

    func goBack() {
        globalData.shazamManager.stopMatching()
        globalData.matching = false
        foundText = ""
        
        globalData.catalog = SHCustomCatalog()
        globalData.catalogGenerated = false
    }

    func saveSignatures() {
        guard let url = globalData.fileManager.selectDirectory(savingCatalog: false) else { return }
        
        var title = "Successfully Saved!"
        var info = "The signatures have been saved."
        var succeed = true
        
        do {
            for (sigName, signature) in globalData.signatures {
                try signature.dataRepresentation.write(to: url.appendingPathComponent("\(sigName).shazamsignature", isDirectory: false))
            }
        } catch {
            title = "Error while saving"
            info = "\(error.localizedDescription)"
            succeed = false
        }
        
        NSAlert.alertWith(title: title, info: info, style: succeed ? .informational : .warning).runModal()
    }

    func saveCatalog() {
        guard let url = globalData.fileManager.selectDirectory(savingCatalog: true) else { return }
        var title = "Successfully Saved!"
        var info = "The catalog has been saved."
        var succeed = true
        
        do {
            try globalData.catalog.write(to: url)
        } catch {
            title = "Error while saving"
            info = "\(error.localizedDescription)"
            succeed = false
        }
        
        NSAlert.alertWith(title: title, info: info, style: succeed ? .informational : .warning).runModal()
    }
}
