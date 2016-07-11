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

@objc protocol PlayerDelegate
{
    optional func audioStartPlaying()
    
    optional func audioEndPlaying()
}

@objc protocol RecorderDelegate
{
    optional func audioStartRecord()
    
    optional func audioRecorded(audio: NSData)
}

private let data = AudioController()

class AudioController : NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
    var audioPlayer: AVAudioPlayer!
    
    var audioRecorder: AVAudioRecorder!
    
    var url : NSURL!
    
    weak var playerDelegate : PlayerDelegate?
    
    weak var recorderDelegate : RecorderDelegate?
    
    override init()
    {
        super.init()
        
        let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let str =  documents.stringByAppendingPathComponent("temp.caf")
        self.url = NSURL.fileURLWithPath(str as String)
        
        //        AVEncoderAudioQualityKey: @(AVAudioQualityMedium),
        //        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        //        AVEncoderBitRateKey: @(128000),
        //        AVNumberOfChannelsKey: @(1),
        //        AVSampleRateKey: @(44100)};
        
        let recordSettings : [String: AnyObject] = [AVEncoderAudioQualityKey: AVAudioQuality.Medium.rawValue,
                                                    AVEncoderBitRateKey: 128000,
                                                    AVNumberOfChannelsKey: 1,
                                                    AVSampleRateKey: 44100]
        do
        {
            try self.audioRecorder = AVAudioRecorder(URL:self.url, settings: recordSettings)
            self.audioRecorder.delegate = self
        }
        catch { print("nao foi possivel iniciar o audio recorder!") }
        
        do
        {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: self.url)
            self.audioPlayer?.delegate = self
        }
        catch { print("nao foi possivel iniciar o audio player!") }
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
    
    func isPlaying() -> Bool
    {
        if let player = self.audioPlayer
        {
            return player.playing
        }
        else
        {
            return false
        }
    }
    
    func play(audio: NSData, startingOnPercent: Float?)
    {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setActive(true)
            do
            {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                do
                {
                    try self.audioPlayer = AVAudioPlayer(data: audio)
                    self.audioPlayer?.delegate = self
                    
                    if startingOnPercent != nil
                    {
                        self.audioPlayer.currentTime = self.audioPlayer.duration * Double(startingOnPercent!)
                    }
                    else
                    {
                        self.audioPlayer.currentTime = 0
                    }
                    
                    print("Player: Tocando...")
                    self.audioPlayer.play()
                    self.playerDelegate?.audioStartPlaying?()
                }
                catch{ print("erro ao tentar carregar audio") }
            }
            
        } catch { print("erro ao tentar ativar a sessao de audio") }
    }
    
    func stop()
    {
        if let player = self.audioPlayer
        {
            player.stop()
            self.playerDelegate?.audioEndPlaying?()
        }
    }
    
    func getAudioDuation(audio: NSData) -> NSTimeInterval?
    {
        do { let player = try AVAudioPlayer(data: audio)
            
            let duration = player.duration
            
            return duration
            
        } catch { return nil }
        
    }
    
    func getCurrentAudioPlayer() -> AVAudioPlayer?
    {
        return self.audioPlayer
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
        self.playerDelegate?.audioEndPlaying?()
        print("Player: Terminou!")
    }
    
    
    
    //Gravacao
    func audioRecorderBeginInterruption(recorder: AVAudioRecorder)
    {
        
    }
    
    //Gravacao
    func audioRecorderEndInterruption(recorder: AVAudioRecorder)
    {
        
    }
    
    //Gravacao
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if let data = NSData(contentsOfURL: self.url)
        {
            do { let audio = try AVAudioPlayer(data: data)
                
                let integer = NSInteger(audio.duration)
                
                let seconds = integer % 60
                
                if seconds > 0
                {
                    self.recorderDelegate?.audioRecorded?(data)
                }
                
            } catch {}
        }
    }
    
    
    
}