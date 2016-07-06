//
//  AudioController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 05/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc protocol AudioDelegate
{
    func audioRecorded(audio: NSData)
    
    func audioEndPlaying()
}

private let data = AudioController()

class AudioController : NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
    var audioPlayer: AVAudioPlayer!
    
    var audioRecorder: AVAudioRecorder!
    
    var url : NSURL!
    
    var delegate : AudioDelegate?
    
    override init()
    {
        super.init()
        
        let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let str =  documents.stringByAppendingPathComponent("temp.caf")
        self.url = NSURL.fileURLWithPath(str as String)
        
        let recordSettings : [String: AnyObject] = [AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
                                                    AVEncoderBitRateKey: 320000,
                                                    AVNumberOfChannelsKey: 2,
                                                    AVSampleRateKey: 44100.0]
        do
        {
            try self.audioRecorder = AVAudioRecorder(URL:self.url, settings: recordSettings)
            self.audioRecorder.delegate = self
        }
        catch {}
        
        do
        {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: self.url)
            self.audioPlayer?.delegate = self
        }
        catch {}
    }
    
    class var sharedInstance : AudioController
    {
        return data
    }
    
    func startRecord()
    {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            do
            {
                print("Record: Gravando...")
                try audioSession.setActive(true)
                self.audioRecorder!.record()
            } catch {}
        } catch {}
    }
    
    func stopRecord()
    {
        print("Record: Terminando!")
        self.audioRecorder.stop()
        
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {}
    }
    
    func play()
    {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            print("Player: Tocando...")
            try audioSession.setActive(true)
            self.audioPlayer.play()
            
        } catch { }
    }
    
    /*********************************/
    /******** ADUIO DELEGATES ********/
    /*********************************/
    
    //Reproducao
    func audioPlayerBeginInterruption(player: AVAudioPlayer)
    {
        print("audio was interrupted")
    }
    
    //Reproducao
    func audioPlayerEndInterruption(player: AVAudioPlayer)
    {
        print("audio was not interrupted anymore")
    }
    
    //Reproducao
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        self.delegate?.audioEndPlaying()
        print("Player: Terminou!")
    }
    
    //Gravacao
    func audioRecorderBeginInterruption(recorder: AVAudioRecorder) {
        
    }
    
    //Gravacao
    func audioRecorderEndInterruption(recorder: AVAudioRecorder) {
        
    }
    
    //Gravacao
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if let data = NSData(contentsOfURL: self.url)
        {
            self.delegate?.audioRecorded(data)
            self.play()
        }
    }
    
    
    
}