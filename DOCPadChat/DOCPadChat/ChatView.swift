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
    
    private var receivedImageView : ReceivedImageView!
    
    var button : UIButton!
    
    var image = UIImage(named: "teste") //temp
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.messageBar = ChatMessageBar(width: screenWidth)
        self.addSubview(self.messageBar)
        
        self.button = UIButton(frame: CGRectMake(screenWidth/2, screenHeight/2, 50, 50))
        self.button.setTitle("IMG", forState: .Normal)
        self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.button.addTarget(self, action: #selector(ChatView.openImage), forControlEvents: .TouchUpInside)
        self.addSubview(self.button)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
       self.messageBar.textView.endEditing(true)
    }
    
    func openImage()
    {
        self.receivedImageView = ReceivedImageView(image: self.image!, frame: self.frame)
        self.addSubview(self.receivedImageView)
    }
}