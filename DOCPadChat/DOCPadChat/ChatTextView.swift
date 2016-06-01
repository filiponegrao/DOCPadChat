//
//  ChatTextView.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit



@objc protocol ChatTextViewDelegate : NSObjectProtocol
{
    func textView(textView: ChatTextView, heightIncreased plus: CGFloat)
    
    func textView(textView: ChatTextView, heightDecreased plus: CGFloat)
    
    func textView(textView: ChatTextView, placeholderOff text: String)
    
    func textView(textView: ChatTextView, placeholderOn placeholder: String)
}

class ChatTextView : UITextView, UITextViewDelegate
{
    private var placeholder : String!
    
    private var heightDefault : CGFloat!
    
    private var heightLimit : CGFloat!
    
    private var heightPlus : CGFloat!
    
    weak var chatDelegate : ChatTextViewDelegate?
    
    init(frame: CGRect)
    {
        super.init(frame: frame , textContainer: nil)
        
        self.delegate = self
//        self.layer.borderWidth = 1
        self.heightDefault = frame.size.height
        self.heightLimit = frame.size.height*2
        self.heightPlus = frame.size.height/2
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceHolder(placeholder: String)
    {
        self.placeholder = placeholder
        self.placeHolderOn()
    }
    
    func placeHolderOn()
    {
        self.text = placeholder
        self.font = UIFont(name: "Helvetica", size: 18)
        self.textColor = UIColor.whiteColor()
        
        self.chatDelegate?.textView(self, placeholderOn: self.text)
    }
    
    func placeHolderOff()
    {
        self.text = ""
        self.font = UIFont(name: "Helvetica", size: 16)
        self.textColor = UIColor.whiteColor()
        
        if(self.text.characters.count > 0)
        {
            self.chatDelegate?.textView(self, placeholderOff: self.placeholder)
        }
    }
    
    
    func increaseHeight()
    {
        self.chatDelegate?.textView(self, heightIncreased: self.heightPlus)
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.frame.size.height += self.heightPlus
//            self.frame.origin.y -= self.heightPlus
            
        }) { (success: Bool) in
            
        }
    }
    
    func decreaseHeight()
    {
        self.chatDelegate?.textView(self, heightDecreased: self.heightPlus)
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.frame.size.height -= self.heightPlus
//            self.frame.origin.y += self.heightPlus
            
        }) { (success: Bool) in
            
        }
    }
    
    /**************************************/
    /******** TEXT VIEW DELEGATES *********/
    /**************************************/
    
    func textViewDidChange(textView: UITextView)
    {
        if(self.text.characters.count > 0)
        {
            self.chatDelegate?.textView(self, placeholderOff: self.placeholder)
        }
        else if(self.text.characters.count == 0)
        {
            self.chatDelegate?.textView(self, placeholderOn: self.placeholder)
        }
        
        if (self.contentSize.height > self.frame.size.height + self.heightPlus) && (self.frame.size.height < self.heightLimit)
        {
            self.increaseHeight()
        }
        else if (self.contentSize.height + self.heightPlus < self.frame.size.height) && (self.frame.size.height > self.heightDefault)
        {
            self.decreaseHeight()
        }
        else if (self.contentSize.height < self.frame.size.height && self.frame.size.height > self.heightDefault)
        {
            self.decreaseHeight()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if self.text == placeholder
        {
            self.placeHolderOff()
        }
 
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if self.text == ""
        {
            self.placeHolderOn()
        }

    }

    /**************************************/
    /**************************************/

    
    
}