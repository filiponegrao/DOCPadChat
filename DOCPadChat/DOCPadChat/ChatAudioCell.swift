//
//  ChatAudioCell.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 11/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ChatAudioCell: UICollectionViewCell, PlayerDelegate
{
    private var message : Message!
    
    private var label : UIView!
    
    private var buttonPlay : UIButton!
    
    private var slider : UISlider!
    
    private var timer : NSTimer!
    
    private var durationLabel : UILabel!
    
    private var playedLabel : UILabel!
    
    private var dateLabel : UILabel!
    
    private var indicator : UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.clearColor()
        
        self.label = UIView(frame: CGRectMake(cellMarginH, cellMarginV, audioCellWidth, self.frame.height - cellMarginV*2))
        self.label.backgroundColor = GMColor.grey200Color()
        self.label.layer.cornerRadius = 8
        self.label.clipsToBounds = true
        self.label.layer.borderWidth = 0.3
        self.label.layer.borderColor = UIColor.grayColor().CGColor
        self.addSubview(self.label)
        
        self.buttonPlay = UIButton(frame: CGRectMake(cellMarginH, cellMarginV, self.label.frame.height - cellMarginV*2, self.label.frame.height - cellMarginV*2))
        self.buttonPlay.setImage(UIImage(named: "buttonPlay"), forState: .Normal)
        self.buttonPlay.alpha = 0.3
        self.buttonPlay.addTarget(self, action: #selector(self.buttonClicked), forControlEvents: .TouchUpInside)
        self.label.addSubview(self.buttonPlay)
        
        let origin = self.buttonPlay.frame.origin.x + self.buttonPlay.frame.width + cellMarginH
        
        self.slider = UISlider(frame: CGRectMake(origin, self.buttonPlay.frame.origin.y, self.label.frame.width - origin - cellMarginH, self.label.frame.height - cellMarginV*3))
        self.slider.setThumbImage(UIImage(), forState: .Application)
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.label.addSubview(self.slider)

        self.dateLabel = UILabel(frame: CGRectMake(self.label.frame.width - 40 - cellMarginH, self.label.frame.height - 20,40,20))
        self.dateLabel.text = "28/09"
        self.dateLabel.font = UIFont(name: "Helvetica", size: 11)
        self.dateLabel.textColor = GMColor.grey500Color()
        self.label.addSubview(self.dateLabel)
        
        self.playedLabel = UILabel(frame: CGRectMake(self.slider.frame.origin.x, self.label.frame.height - self.dateLabel.frame.height, self.dateLabel.frame.width, self.dateLabel.frame.height ))
        self.playedLabel.text = "00:00"
        self.playedLabel.font = self.dateLabel.font
        self.playedLabel.textColor = self.dateLabel.textColor
        self.label.addSubview(self.playedLabel)
        
        self.durationLabel = UILabel(frame: CGRectMake(self.playedLabel.frame.origin.x + self.playedLabel.frame.width, self.label.frame.height - self.dateLabel.frame.height, self.dateLabel.frame.width*1.5, self.dateLabel.frame.height ))
        self.durationLabel.text = "/ 00:00"
        self.durationLabel.font = self.dateLabel.font
        self.durationLabel.textColor = self.dateLabel.textColor
        self.label.addSubview(self.durationLabel)
        
//        self.indicator = UIImageView(frame: CGRectMake(0, 0, cellMarginH*2, cellMarginH*2))
//        self.indicator.contentMode = .ScaleAspectFit
//        self.indicator.backgroundColor = UIColor.clearColor()
//        self.indicator.alpha = 0.4
//        self.label.addSubview(self.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(message: Message)
    {
        self.message = message
        
        self.dateLabel.text = UseFulFunctions.getStringDateFromDate(self.message.sentDate)
        
        if let file = message.file
        {
            if let duration = AudioController.sharedInstance.getAudioDuation(file.content)
            {
                let ti = NSInteger(duration)
                let minutes = (ti / 60) % 60
                let seconds = ti % 60
                let string = NSString(format: "/ %0.2d:%0.2d", minutes, seconds)
                self.durationLabel.text = string as String
            }
        }
        
        if let id = ChatApplication.sharedInstance.getId()
        {
            //Usuario corrente é o sender
            if message.sender == id
            {
                self.label.frame.origin.x = screenWidth - self.label.frame.width - cellMarginH
                self.label.backgroundColor = GMColor.grey300Color()
                self.dateLabel.textColor = GMColor.grey700Color()
                
            }
            else
            {
                self.label.frame.origin.x = cellMarginH
                self.label.backgroundColor = GMColor.grey200Color()
            }
        }
        
        self.label.layer.shadowColor = UIColor.blackColor().CGColor
        self.label.layer.shadowOffset = CGSizeMake(1, 2.0);
        self.label.layer.shadowRadius = 2.0
        self.label.layer.shadowOpacity = 0.2
        self.label.layer.masksToBounds = false
        self.label.layer.shadowPath = UIBezierPath.init(roundedRect: self.label.bounds, cornerRadius: self.label.layer.cornerRadius).CGPath
    }
    
    func buttonClicked()
    {
        if AudioController.sharedInstance.isPlaying()
        {
            AudioController.sharedInstance.stop()
        }
        else
        {
            if let file = message.file
            {
                AudioController.sharedInstance.playerDelegate = self
                AudioController.sharedInstance.play(file.content, startingOnPercent: self.slider.value/100)
            }
        }
    }
    
    func updateTimeLabel()
    {
        if let audioPlayer = AudioController.sharedInstance.getCurrentAudioPlayer()
        {
            let current = audioPlayer.currentTime
            let duration = audioPlayer.duration
            
            let time = NSInteger(current)
            
            let seconds = time % 60
            let minutes = (time / 60) % 60
            
            let string = NSString(format: "%0.2d:%0.2d",minutes,seconds)
            
            self.playedLabel.text = string as String
            self.slider.value = Float((current * 100.0) / duration)
        }
    }
    
    func audioStartPlaying()
    {
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
        self.buttonPlay.setImage(UIImage(named: "buttonPause"), forState: .Normal)
    }
    
    func audioEndPlaying()
    {
        self.slider.value = 0
        self.playedLabel.text = "00:00"
        self.timer?.invalidate()
        self.buttonPlay.setImage(UIImage(named: "buttonPlay"), forState: .Normal)
    }
    
    
}