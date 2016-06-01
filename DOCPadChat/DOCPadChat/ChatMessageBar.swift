//
//  ChatMessageBar.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit


class ChatMessageBar : UIView
{
    private let height : CGFloat = 80;
    
    private var textView : UITextView!
    
    private var sendButton : UIButton!
    
    private var audioButton : UIButton!
    
    private var photoButton : UIButton!
    
    init(width: CGFloat)
    {
        super.init(frame: CGRectMake(0, screenHeight - self.height, width, self.height))
        
        self.backgroundColor = blueColor;
        
        
        self.photoButton = UIButton(frame: CGRectMake(0, 0, self.height, self.height))
        self.photoButton.setTitle("Photo", forState: .Normal)
        self.photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addSubview(self.photoButton)
    
        
        self.audioButton = UIButton(frame: CGRectMake(width - self.height, 0, self.height, self.height))
        self.audioButton.setTitle("Gravar", forState: .Normal)
        self.audioButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addSubview(self.audioButton)
        
        self.textView = UITextView(frame: CGRectMake(self.photoButton.bounds.width, self.height/4, width - self.audioButton.frame.size.width - self.audioButton.frame.size.width, 40))
        self.textView.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.textView)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}