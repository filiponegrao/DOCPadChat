//
//  ChatController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    /******* Chat Variables *********/

    private var channel : Channel!
    
    private var messages: [Message] = [Message]()
    
    private var chatView : ChatView!
    
    /********************************/
    
    private var receivedImageView : ReceivedImageView!
    
    var leftButton : UIBarButtonItem!
    
    var rightButton : UIBarButtonItem!
    
    var button : UIButton!
    
    
    init(channel: Channel)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.channel = channel
    }

    override func viewDidLayoutSubviews()
    {
    
    }
    
    /********************************/
    /***** Refresh Controllers ******/
    /********************************/
    
    override func viewWillAppear(animated: Bool)
    {
        self.messages = DAOMessage.sharedInstance.getMessagesFromChannel(Int(self.channel.id))
        
        self.chatView.collectionView.reloadData()
        self.chatView.updateView(self.channel)
    }
    
    func refreshChat(channel: Channel)
    {
        self.channel = channel
        self.messages = DAOMessage.sharedInstance.getMessagesFromChannel(Int(self.channel.id))
        self.chatView.collectionView.reloadData()
        
        self.chatView.updateView(self.channel)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /********************************/
    /******** Chat Methods **********/
    /********************************/
    

    
    /********************************/
    /********************************/

    override func viewDidLoad()
    {
        self.chatView = ChatView(frame: CGRectMake(0,0,screenWidth,screenHeight), controller: self)
        
        self.view = self.chatView
        
        //Notifications
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNewMessage(_:)), name: Event.message_new.rawValue, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
    }
    
    
    /********************************/
    /******** Tools Methods *********/
    /********************************/
    
    func openGallery()
    {
        let sentMediaController = SentMediaController()
        self.navigationController?.pushViewController(sentMediaController, animated: true)
    }
    
    func openImage()
    {
//        self.receivedImageView = ReceivedImageView(image: self.image!, frame: self.view.frame, requester: self)
//        self.navigationController!.view.addSubview(self.receivedImageView)
    }
    
    /********************************/
    /********************************/
    
    /********************************/
    /** Collection View Delegate ****/
    /********************************/
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let message = self.messages[indexPath.item]
        
        if message.type == MessageType.Text.rawValue
        {
            let height = ChatTextCell.getHeightForCell(forMessage: message)
            
            return CGSizeMake(screenWidth, height)
        }
        
        return CGSizeMake(screenWidth, 60)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.view.endEditing(true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let message = self.messages[indexPath.item]
        
        let type = message.type
        
        if type == MessageType.Text.rawValue
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellText", forIndexPath: indexPath) as! ChatTextCell
            
//            if(indexPath.item % 2 == 0) { cell.backgroundColor = UIColor.redColor() }
//            else { cell.backgroundColor = UIColor.blueColor() }
            
            cell.configureCell(message)
            
            return cell
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    }
    
    
    /********************************/
    /***** Conversation Methods *****/
    /********************************/

    func handleNewMessage(notification: NSNotification)
    {
        if let userinfo = notification.userInfo
        {
            let channel = userinfo["channel"] as! Int
            let message = userinfo["message"] as! Message
            
            if channel != Int(self.channel.id) { return }
            
            self.messages = DAOMessage.sharedInstance.getMessagesFromChannel(Int(self.channel.id))

            if let index = self.messages.indexOf(message)
            {
                self.chatView.collectionView.insertItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
            }
            else
            {
                self.chatView.collectionView.reloadData()
            }
            
        }
    }

    
    /********************************/
    /********************************/
    
}