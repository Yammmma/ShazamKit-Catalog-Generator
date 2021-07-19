//
//  GeneratingCatalogView.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import SwiftUI

struct GeneratingCatalogView: View {
    @ObservedObject var globalData: GlobalData
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Indicator()
                Text("Generating... (\(globalData.progress) of \(globalData.files.count))")
                    .font(.title)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct Indicator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator(frame: NSRect(origin: .zero, size: NSSize(width: 100, height: 100)))
        indicator.style = .spinning
        indicator.startAnimation(self)
        
        return indicator
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {}
}
