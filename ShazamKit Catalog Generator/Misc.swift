//
//  Misc.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import AVFoundation
import SwiftUI

struct File: Identifiable {
    let asset: AVAudioFile
    let name: String
    let type: String
    let duration: String
    let path: String
    let url: URL
    let id = UUID()
}

extension Double {
    func toMinsSecs() -> (Int, Int) { (Int(self / 60), Int(self.truncatingRemainder(dividingBy: 60))) }
}

extension NSAlert {
    static func alertWith(title: String, info: String, style: NSAlert.Style) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = info
        alert.alertStyle = style
        alert.addButton(withTitle: "OK")
        
        return alert
    }
}
