//
//  ChatTextView.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit



@objc protocol ChatTextViewDelegate
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
    
    private var defaulFont = UIFont(name: "Helvetica", size: 16)!
    
    weak var chatDelegate : ChatTextViewDelegate?
    
    private var mainSize: CGSize!
    
    private var heights : [CGFloat]!
    
    init(placeholder: String)
    {
        let frame = CGRectMake(0, 0, screenWidth, 100)
        super.init(frame: frame , textContainer: nil)
        
        self.font = self.defaulFont
        self.placeholder = placeholder
        self.text = self.placeholder
        self.frame.size.height = self.contentSize.height
        self.delegate = self
        
        self.placeHolderOn()
        self.heightDefault = self.frame.size.height
        self.heightLimit = self.frame.size.height*2
        self.heightPlus = self.frame.size.height/2
        
        self.mainSize = CGSizeMake(frame.width, frame.height)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeHolderOn()
    {
        self.text = placeholder
        self.textColor = UIColor.whiteColor()
        
        self.chatDelegate?.textView(self, placeholderOn: self.text)
    }
    
    func placeHolderOff()
    {
        self.text = ""
        self.textColor = UIColor.whiteColor()
        
        if(self.text.characters.count > 0)
        {
            self.chatDelegate?.textView(self, placeholderOff: self.placeholder)
        }
    }
    
    func defaultSize()
    {
        UIView.animateWithDuration(0.3, animations: { 
            
            self.frame.size.height = self.heightDefault
            
        }) { (success: Bool) in
            
        }
    }
    
    func increaseHeight()
    {
        self.chatDelegate?.textView(self, heightIncreased: self.heightPlus)
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.frame.size.height += self.heightPlus //5 de margem default
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
            self.defaultSize()
        }
        if (self.contentSize.height > self.frame.size.height + 5) && (self.frame.size.height < self.heightLimit)
        {
            self.increaseHeight()
        }
        else if (self.contentSize.height < self.frame.size.height) && (self.frame.size.height > self.heightDefault)
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