//
//  ChatController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatController : UIViewController
{
    
    private var chatView : ChatView!
    
    
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.chatView = ChatView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        
        
        self.view = self.chatView
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}