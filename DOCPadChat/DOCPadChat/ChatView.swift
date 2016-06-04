//
//  ChatView.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatView : UIView
{
    private var messageBar : ChatMessageBar!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.messageBar = ChatMessageBar(width: screenWidth)
        self.addSubview(self.messageBar)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleKeyboardUp(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleKeyboardDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
       self.messageBar.textView.endEditing(true)
    }
    
    /*********************************/
    /********** ANIMATIONS ***********/
    /*********************************/
    
    func handleKeyboardUp(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.messageBar.frame.origin.y = screenHeight - keyboardSize.height - self.messageBar.frame.size.height
        }
    }
    
    func handleKeyboardDown(notification: NSNotification)
    {
        self.messageBar.frame.origin.y = screenHeight - self.messageBar.frame.size.height
    }
    
    
    /*********************************/
    /*********************************/


}