//
//  ChatMessageBar.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit


@objc protocol ChatMessageBarDelegate
{
    func messageBarPhotoClicked(messageBar: ChatMessageBar)
    
    func messageBarAudioClicked(messageBar: ChatMessageBar)
    
    func messageBarSendClicked(messageBar: ChatMessageBar, text: String)
    
    func messageBarIncreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
    
    func messageBarDecreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
}

class ChatMessageBar : UIView, ChatTextViewDelegate
{
    private let height : CGFloat = 60;
    
    var textView : ChatTextView!
    
    private var sendButton : UIButton!
    
    private var audioButton : UIButton!
    
    private var photoButton : UIButton!
    
    var delegate : ChatMessageBarDelegate?
    
    init(width: CGFloat)
    {
        super.init(frame: CGRectMake(0, screenHeight - self.height, width, self.height))
        
        self.backgroundColor = blueColor;
        
        
        self.photoButton = UIButton(frame: CGRectMake(0, 0, self.height, self.height))
//        self.photoButton.setTitle("Photo", forState: .Normal)
//        self.photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.photoButton.setImage(UIImage(named: "buttonCamera"), forState: .Normal)
        self.photoButton.addTarget(self, action: #selector(self.handleClickPhoto), forControlEvents: .TouchUpInside)
        self.addSubview(self.photoButton)
    
        
        self.audioButton = UIButton(frame: CGRectMake(width - self.height, 0, self.height, self.height))
        self.audioButton.setImage(UIImage(named: "buttonMic"), forState: .Normal)
//        self.audioButton.setTitle("Gravar", forState: .Normal)
//        self.audioButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.audioButton.addTarget(self, action: #selector(self.handleClickAudio), forControlEvents: .TouchUpInside)
        self.addSubview(self.audioButton)
        
        self.sendButton = UIButton(frame: self.audioButton.frame)
        self.sendButton.setTitle("Enviar", forState: .Normal)
        self.sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.sendButton.addTarget(self, action: #selector(self.handleClickSend), forControlEvents: .TouchUpInside)
        self.sendButton.hidden = true
        self.addSubview(self.sendButton)
        
        self.textView = ChatTextView(frame: CGRectMake(self.photoButton.bounds.width, self.height/4, width - self.audioButton.frame.size.width - self.audioButton.frame.size.width, self.height/2))
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.textColor = UIColor.whiteColor()
        self.textView.setPlaceHolder("Message...")
        self.textView.chatDelegate = self
        
        
        self.textView.layer.borderWidth = 1
        
        self.addSubview(self.textView)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**************************************/
    /************ ANIMATIONS **************/
    /**************************************/
    
    func textModeOn()
    {
        UIView.animateWithDuration(0.3, animations: { 
            
            self.audioButton.alpha = 0
            self.sendButton.alpha = 1
            
        }) { (success: Bool) in
            
            self.audioButton.hidden = true
            self.sendButton.hidden = false
        }
    }
    
    func textModeOff()
    {
        UIView.animateWithDuration(0.3, animations: {
            
            self.audioButton.alpha = 1
            self.sendButton.alpha = 0
            
        }) { (success: Bool) in
            
            self.audioButton.hidden = false
            self.sendButton.hidden = true
        }
    }
    
    
    /**************************************/
    /**************************************/

    
    func handleClickAudio()
    {
        self.delegate?.messageBarAudioClicked(self)
    }
    
    func handleClickPhoto()
    {
        self.delegate?.messageBarPhotoClicked(self)
    }
    
    func handleClickSend()
    {
        self.delegate?.messageBarSendClicked(self, text: self.textView.text)
        self.textView.text = ""
    }
    

    /**************************************/
    /******** TEXT VIEW DELEGATES *********/
    /**************************************/
    
    func textView(textView: ChatTextView, heightDecreased plus: CGFloat)
    {
        self.delegate?.messageBarDecreasedSize(self, plus: plus)
        
        UIView.animateWithDuration(0.3, animations: { 
            self.frame.origin.y += plus
            self.frame.size.width -= plus
            
        }) { (success: Bool) in
            
        }
    }
    
    func textView(textView: ChatTextView, heightIncreased plus: CGFloat)
    {
        self.delegate?.messageBarIncreasedSize(self, plus: plus)
        
        UIView.animateWithDuration(0.3, animations: {
            self.frame.origin.y -= plus
            self.frame.size.width += plus
            
        }) { (success: Bool) in
            
        }
    }
    
    func textView(textView: ChatTextView, placeholderOff text: String)
    {
        self.textModeOn()
    }
    
    func textView(textView: ChatTextView, placeholderOn placeholder: String)
    {
        self.textModeOff()
    }
    
    /**************************************/
    /**************************************/

    
    
    
}