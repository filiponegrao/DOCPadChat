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
    
    private var receivedImageView : ReceivedImageView!
    
    var leftButton : UIBarButtonItem!
    
    var rightButton : UIBarButtonItem!
    
    var button : UIButton!
    
    var image = UIImage(named: "teste") //temp
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.chatView = ChatView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        
        self.view = self.chatView
        
        self.rightButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(self.openGallery))
        self.rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        
        self.button = UIButton(frame: CGRectMake(screenWidth/2, screenHeight/2, 50, 50))
        self.button.setTitle("IMG", forState: .Normal)
        self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.button.addTarget(self, action: #selector(self.openImage), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.button)
    }
    
    override func viewDidLayoutSubviews()
    {
    
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        
    }
    
    func openGallery()
    {
        let sentMediaController = SentMediaController()
        
        self.navigationController?.pushViewController(sentMediaController, animated: true)
    }
    
    func openImage()
    {
        self.receivedImageView = ReceivedImageView(image: self.image!, frame: self.view.frame, requester: self)
        self.navigationController!.view.addSubview(self.receivedImageView)
    }
}