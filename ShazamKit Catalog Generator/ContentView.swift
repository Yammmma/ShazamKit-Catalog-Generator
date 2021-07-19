//
//  ContentView.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 11/6/21.
//

import SwiftUI
import Cocoa
import ShazamKit

class GlobalData: ObservableObject {
    let fileManager = FileManager()
    let shazamManager = ShazamManager()
    
    @Published var files = [File]()
    @Published var signatures = [String : SHSignature]()
    @Published var catalog = SHCustomCatalog()
    @Published var catalogGenerated = false
    @Published var generating = false
    @Published var matching = false
    @Published var progress = 0
}

struct ContentView: View {
    @ObservedObject var globalData = GlobalData()
    
    var body: some View {
        if globalData.catalogGenerated {
            GeneratedCatalogView(globalData: globalData)
        } else if globalData.generating {
            GeneratingCatalogView(globalData: globalData)
        } else {
            FileSelection(globalData: globalData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
