//
//  ShazamManager.swift
//  ShazamKit Catalog Generator
//
//  Created by Yuma Soerianto on 18/7/21.
//

import AVFoundation
import ShazamKit

class ShazamManager: NSObject, SHSessionDelegate {
    let engine = AVAudioEngine()
    var session: SHSession?
    var foundMatch: ((String) -> ())?
    
    func catalog(from files: [File], signatureGenerated: (Int) -> ()) -> (SHCustomCatalog, [String : SHSignature]) {
        let catalog = SHCustomCatalog()
        var signatures = [String : SHSignature]()
        
        var signaturesGend = 0
        for file in files {
            signature(from: file.asset) { signature in
                try? catalog.addReferenceSignature(signature, representing: [SHMediaItem(properties: [.title : file.name])])
                signatures[file.name] = signature
                
                signaturesGend += 1
                signatureGenerated(signaturesGend)
            }
        }
        
        return (catalog, signatures)
    }
    
    func signature(from asset: AVAudioFile, completion: (SHSignature) -> ()) {
        let signatureGenerator = SHSignatureGenerator()
        
        buffer(from: asset) { buffer in
            try? signatureGenerator.append(buffer, at: nil)
        } completion: {
            completion(signatureGenerator.signature())
        }
    }
    
    func buffer(from asset: AVAudioFile, receivedBuffer: (AVAudioPCMBuffer) -> (), completion: () -> ()) {
        guard let outputFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1) else { return completion() }
        let frameCount = AVAudioFrameCount(65536 / asset.processingFormat.streamDescription.pointee.mBytesPerFrame)
        let outputFrameCapacity = AVAudioFrameCount(round(Double(frameCount) * (outputFormat.sampleRate / asset.processingFormat.sampleRate)))
        
        guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: asset.processingFormat, frameCapacity: frameCount),
              let outputBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: outputFrameCapacity) else { return completion() }
        guard let converter = AVAudioConverter(from: asset.processingFormat, to: outputFormat) else { return completion() }
        
        while true {
            let status = converter.convert(to: outputBuffer, error: nil) { inNumPackets, outStatus in
                do {
                    try asset.read(into: inputBuffer)
                    outStatus.pointee = .haveData
                    return inputBuffer
                } catch {
                    if asset.framePosition >= asset.length {
                        outStatus.pointee = .endOfStream
                    } else {
                        outStatus.pointee = .noDataNow
                    }
                    
                    return nil
                }
            }
            
            if status == .error || status == .endOfStream {
                return completion()
            }

            receivedBuffer(outputBuffer)

            if status == .inputRanDry {
                return completion()
            }

            inputBuffer.frameLength = 0
            outputBuffer.frameLength = 0
        }
    }
    
    func startMatching(with catalog: SHCatalog, foundMatch: @escaping (String) -> ()) {
        session = SHSession(catalog: catalog)
        session?.delegate = self
        
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: engine.inputNode.outputFormat(forBus: 0).sampleRate,
                                        channels: 1)
        engine.inputNode.installTap(onBus: 0, bufferSize: 2048, format: audioFormat) { [weak session] buffer, audioTime in
            session?.matchStreamingBuffer(buffer, at: audioTime)
        }
        
        try? engine.start()
        
        self.foundMatch = foundMatch
    }
    
    func stopMatching() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        foundMatch = nil
        session = nil
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        guard let item = match.mediaItems.first,
              let title = item.title else { return }
        
        DispatchQueue.main.async {
            self.foundMatch?(title)
        }
    }
}
