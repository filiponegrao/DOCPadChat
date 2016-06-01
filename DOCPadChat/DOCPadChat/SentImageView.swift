//
//  SentImageView.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class SentImageView: UIView
{
    var viewController : SentMediaController!
    
    var image : UIImage!
    
    var selectedMedia : UIImageView!
    
    var sendButton : UIButton!
    
    var deleteButton : UIButton!
    
    var closeButton : UIButton!
    
    var blackScreen : UIView!
    
    init(image: UIImage, requester: SentMediaController)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.image = image
        self.viewController = requester
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.9
        self.addSubview(self.blackScreen)
        
        self.selectedMedia = UIImageView(frame: CGRectMake(screenWidth/14, screenHeight/6, screenWidth - (screenWidth/14 * 2), screenHeight/8 * 5))
        self.selectedMedia.image = self.image
        self.selectedMedia.contentMode = .ScaleAspectFit
        self.addSubview(self.selectedMedia)
        
        self.closeButton = UIButton(frame: CGRectMake(0, 25, 80, 44))
        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.closeButton.setTitle("Fechar", forState: .Normal)
        self.closeButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.closeButton.alpha = 1
        self.addSubview(self.closeButton)
        
        self.sendButton = UIButton(frame: CGRectMake(0, screenHeight - 50, screenWidth/2, 50))
        self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2
        self.sendButton.clipsToBounds = true
        self.sendButton.setTitle("Enviar", forState: .Normal)
        self.sendButton.contentMode = .ScaleAspectFill
        self.sendButton.addTarget(self, action: "sendPhoto", forControlEvents: .TouchUpInside)
        self.addSubview(self.sendButton)
        
        self.deleteButton = UIButton(frame: CGRectMake(screenWidth/2, screenHeight - 50, screenWidth/2, 50))
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.height/2
        self.deleteButton.clipsToBounds = true
        self.deleteButton.setTitle("Apagar", forState: .Normal)
        self.deleteButton.addTarget(self, action: "deletePhoto", forControlEvents: .TouchUpInside)
        self.addSubview(self.deleteButton)

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deletePhoto()
    {
        //TO DO
    }
    
    func sendPhoto()
    {
        //TO DO
    }
    
    func back()
    {
        self.removeFromSuperview()
    }
}