//
//  MainNavigationController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit


class ChatNavigationController : UINavigationController
{
    private var chatController : ChatController!
    
    init(userModel: UserModel)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.chatController = ChatController(usermodel: userModel)
        
        self.viewControllers = [self.chatController]
        
        //Navigation customizations
        
        self.navigationBar.barTintColor = blueColor;
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barStyle = .Default
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}