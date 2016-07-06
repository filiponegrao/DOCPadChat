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


class AudioController : NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
//    var audioPlayer: AVAudioPlayer!
//    
//    var audioRecorder: AVAudioRecorder!
//    
//    var url : NSURL!
//    
//    override init()
//    {
//        let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
//        let str =  documents.stringByAppendingPathComponent("temp.caf")
//        self.url = NSURL.fileURLWithPath(str as String)
//        
//        let recordSettings : [String: AnyObject] = [AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
//                                                    AVEncoderBitRateKey: 16,
//                                                    AVNumberOfChannelsKey: 2,
//                                                    AVSampleRateKey: 44100.0]
//        do
//        {
//            try self.audioRecorder = AVAudioRecorder(URL:self.url, settings: recordSettings)
//            self.audioRecorder.delegate = self
//        }
//        catch {}
//        
//    }
//    
//    func record()
//    {
//        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
//        do
//        {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            
//            do
//            {
//                try audioSession.setActive(true)
//                
//                self.audioRecorder!.record()
//            }
//            catch
//            {
//                
//            }
//        }
//        catch
//        {
//            
//        }
//    }
//    
//    func play()
//    {
//        
//    }
//    
//    /*********************************/
//    /******** ADUIO DELEGATES ********/
//    /*********************************/
//    
//    //Reproducao
//    func audioPlayerBeginInterruption(player: AVAudioPlayer)
//    {
//        print("audio was interrupted")
//    }
//    
//    //Reproducao
//    func audioPlayerEndInterruption(player: AVAudioPlayer)
//    {
//        print("audio was not interrupted anymore")
//    }
//    
//    //Reproducao
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
//    {
//        print("audio player finished")
//    }
    
    
    
}