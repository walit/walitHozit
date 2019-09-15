//
//  AudioPlayView.swift
//  Walt Howzlt
//
//  Created by My on 02/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class AudioPlayView: UIView {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblTotolDuration: UILabel!
   
    var url = String()
    var callBackFinishPlay: (()->())?
    let audioPlayer = AudioPlayer()
    
    func initPlayerView(){
        btnPlay.setImage(UIImage(named:"round-pause-button"), for: .normal)
        btnPlay.tag = 1
        lblDuration.text = "0:00"
        lblTotolDuration.text = "05:00"
        btnPlay.layer.cornerRadius = 4
        addGradientWithColor()
        audioPlayer.url = self.url
        audioPlayer.initAudioPlayer()
        audioPlayer.registerNotification()
        audioPlayer.playSound(soundUrl: url)
        audioPlayer.callBackReadToPlay = {
            self.removeFromSuperview()
            self.callBackFinishPlay?()
        }
        self.audioPlayer.playSound()
    }
    @IBAction func btnPlay(_ sender: Any) {
        if self.audioPlayer.isplay {
            self.audioPlayer.pause()
            btnPlay.setImage(UIImage(named:"play"), for: .normal)
        }else{
            self.audioPlayer.playSound()
            btnPlay.setImage(UIImage(named:"round-pause-button"), for: .normal)
        }
        
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.removeFromSuperview()
        self.audioPlayer.pause()
        callBackFinishPlay?()
    }
    func addGradientWithColor(){
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = btnPlay.frame.size
        gradientLayer.colors = [myColors.gradientLow.cgColor, myColors.gradientHigh.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        btnPlay.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
