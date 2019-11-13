//
//  AudioRecordingView.swift
//  Walt Howzlt
//
//  Created by Kavita on 26/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordingView: UIView ,AVAudioRecorderDelegate{
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgBlink: UIImageView!
    var callbackFinish: ((Data)->())?
    var audioFilename : URL?
    var timeMin = 0
    var timeSec = 0
    weak var timer: Timer?
    
    func setupRecording(){
        resetTimerToZero()
        resetTimerAndLabel()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    func loadRecordingUI() {
            startRecording()
            self.startTimer()
    }
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
           
        } catch {
            finishRecording(success: false)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        stopTimer()
        self.isHidden = true
    }
   
    @IBAction func btnCancel(_ sender: Any) {
        self.finishRecording(success: true)
    }
    
    @IBAction func btnOk(_ sender: Any) {
        self.finishRecording(success: true)
        do {
            let data = try Data.init(contentsOf: audioFilename!)
            callbackFinish?(data)
        }catch{
            print("error")
        }
       
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    fileprivate func startTimer(){
        
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        lblDuration.text = timeNow
        
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    @objc fileprivate func timerTick(){
        timeSec += 1
        if timeSec % 2 == 0 {
            self.imgBlink.isHidden = true
        }else{
            self.imgBlink.isHidden = false
        }
        if timeSec == 60{
            timeSec = 0
            timeMin += 1
        }
        
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        
        lblDuration.text = timeNow
    }
  
    @objc fileprivate func resetTimerToZero(){
        timeSec = 0
        timeMin = 0
        stopTimer()
    }
   
    @objc fileprivate func resetTimerAndLabel(){
    
        resetTimerToZero()
        lblDuration.text = String(format: "%02d:%02d", timeMin, timeSec)
    }
    
    // stops the timer at it's current time
    @objc fileprivate func stopTimer(){
        timer?.invalidate()
    }
}
