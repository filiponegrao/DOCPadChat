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
    
    func messageBarStartAudioClicked(messageBar: ChatMessageBar)
    
    func messageBarEndAudioClicked(messageBar: ChatMessageBar)
    
    func messageBarSendClicked(messageBar: ChatMessageBar, text: String)
    
    func messageBarIncreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
    
    func messageBarDecreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
}

class ChatMessageBar : UIView, ChatTextViewDelegate
{
    private var height : CGFloat = 1;
    
    var textView : ChatTextView!
    
    var sendButton : UIButton!
    
    var audioButton : UIButton!
    
    var photoButton : UIButton!
    
    var delegate : ChatMessageBarDelegate?
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, 1))
        
        self.backgroundColor = blueColor;
        
        self.textView = ChatTextView(placeholder: "Mensagem....")
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.chatDelegate = self
        
        self.height = self.textView.frame.height + 20 // 10 pra cima e 10 pra baixo
        self.frame.size.height = self.height
        
        self.photoButton = UIButton(frame: CGRectMake(0, 0, self.height, self.height))
        self.photoButton.setImage(UIImage(named: "buttonCamera"), forState: .Normal)
        self.photoButton.addTarget(self, action: #selector(self.handleClickPhoto), forControlEvents: .TouchUpInside)
        self.addSubview(self.photoButton)
    
        self.audioButton = UIButton(frame: CGRectMake(self.frame.width - self.height, 0, self.height, self.height))
        self.audioButton.setImage(UIImage(named: "buttonMic"), forState: .Normal)
        
        self.audioButton.addTarget(self, action: #selector(self.handleStartClickAudio), forControlEvents: .TouchDown)
        self.audioButton.addTarget(self, action: #selector(self.handleEndClickAudio), forControlEvents: .TouchUpInside)
        
        self.addSubview(self.audioButton)
        
        self.sendButton = UIButton(frame: self.audioButton.frame)
        self.sendButton.setTitle("Enviar", forState: .Normal)
        self.sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.sendButton.addTarget(self, action: #selector(self.handleClickSend), forControlEvents: .TouchUpInside)
        self.sendButton.hidden = true
        self.addSubview(self.sendButton)
        
        self.textView.frame.size.width = self.frame.width - self.sendButton.frame.width - self.photoButton.frame.width
        self.textView.frame.origin.x = self.photoButton.bounds.width
        self.textView.frame.origin.y = 10
        
        self.addSubview(self.textView)
        
        self.frame.origin = CGPointMake(0, screenHeight - self.frame.height)
        
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

    
    func handleStartClickAudio()
    {
        self.delegate?.messageBarStartAudioClicked(self)
    }
    
    func handleEndClickAudio()
    {
        self.delegate?.messageBarEndAudioClicked(self)
    }
    
    func handleClickPhoto()
    {
        self.delegate?.messageBarPhotoClicked(self)
    }
    
    func handleClickSend()
    {
        self.delegate?.messageBarSendClicked(self, text: self.textView.text)
        if self.textView.isFirstResponder()
        {
            self.textView.text = ""
            self.textView.defaultSize()
            self.animateToOriginalHeight()

        }
        else
        {
            self.textView.placeHolderOn()
            self.textView.defaultSize()
            self.animateToOriginalHeight()
        }
    }

    func animateToOriginalHeight()
    {
        let currentHeight = self.frame.size.height
        let difference = currentHeight - self.height
        
        self.delegate?.messageBarDecreasedSize(self, plus: difference)
        
        UIView.animateWithDuration(0.3, animations: { 
            
            self.frame.size.height = self.height
            self.frame.origin.y += difference
            
        }) { (success: Bool) in
            
        }
    }

    /**************************************/
    /******** TEXT VIEW DELEGATES *********/
    /**************************************/
    
    func textView(textView: ChatTextView, heightDecreased plus: CGFloat)
    {
        self.delegate?.messageBarDecreasedSize(self, plus: plus)
        
        UIView.animateWithDuration(0.3, animations: { 
            self.frame.origin.y += plus
            self.frame.size.height -= plus
            
        }) { (success: Bool) in
            
        }
    }
    
    func textView(textView: ChatTextView, heightIncreased plus: CGFloat)
    {
        self.delegate?.messageBarIncreasedSize(self, plus: plus)
        
        UIView.animateWithDuration(0.3, animations: {
            self.frame.origin.y -= plus
            self.frame.size.height += plus
            
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