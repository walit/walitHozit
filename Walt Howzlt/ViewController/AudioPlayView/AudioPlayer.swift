//
//  AudioPlayer.swift
//  Walit
//
//  Created by Kavita on 13/08/19.
//  Copyright © 2019 Walit. All rights reserved.
//

import UIKit
import AVFoundation
class AudioPlayer: NSObject {
    static let audioPLayer = AudioPlayer()
    var url = String()
   var isplay = false
    var audioSession = AVAudioSession.sharedInstance() // we only need to instantiate this once
    lazy var playerQueue : AVQueuePlayer = {
        return AVQueuePlayer()
    }()
    
    var callBackReadToPlay: (()->())?
    
    func initAudioPlayer(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.animationDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    func pause(){
         self.playerQueue.pause()
         isplay =    false
    }
    func playSound(){
        isplay = true
        self.playSound(soundUrl: self.url)
    }
    func playSound (soundUrl: String){
        if let url = URL.init(string: soundUrl) {
            let playerItem = AVPlayerItem.init(url: url)
            self.playerQueue.insert(playerItem, after: nil)
            self.playerQueue.play()
            
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func animationDidFinish(_ notification: NSNotification) {
        print("Animation did finish")
        callBackReadToPlay?()
    }
}

