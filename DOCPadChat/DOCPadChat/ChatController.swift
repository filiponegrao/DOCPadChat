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

//    private var channel : Channel!
    
    private var usermodel : UserModel!
    
    private var messages: [Message] = [Message]()
    
    private var chatView : ChatView!
    
    /********************************/
    
    private var receivedImageView : ReceivedImageView!
    
    var leftButton : UIBarButtonItem!
    
    var rightButton : UIBarButtonItem!
    
    var button : UIButton!
    
    func currentUserModel() -> UserModel
    {
        return self.usermodel
    }
    
    init(usermodel: UserModel)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.usermodel = usermodel
    }

    override func viewDidLayoutSubviews()
    {
    
    }
    
    /********************************/
    /***** Refresh Controllers ******/
    /********************************/
    

    

    
    func refreshChat(usermodel: UserModel)
    {
        self.usermodel = usermodel
        self.messages = DAOMessage.sharedInstance.getMessagesFrom(self.usermodel.id)
        self.chatView.collectionView.reloadData()
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
    
    override func viewWillAppear(animated: Bool)
    {
        self.messages = DAOMessage.sharedInstance.getMessagesFrom(self.usermodel.id)
        
        for m in self.messages
        {
            print("Id: ", m.id, "Texto: ", m.text)
        }
        
        self.chatView.collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {

    }
    
    override func viewWillDisappear(animated: Bool)
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
            let sender = userinfo["sender"] as! String
            let message = userinfo["message"] as! Message
            
            //Verifica se o remetente é o mesmo
            if sender != self.usermodel.id && sender != ChatApplication.sharedInstance.getId() { return }
            
            self.messages = DAOMessage.sharedInstance.getMessagesFrom(self.usermodel.id)

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
    
    func sendTextMessage(text: String)
    {
        ChatApplication.sharedInstance.sendMessage(text, toId: self.usermodel.id)
    }

    
    /********************************/
    /********************************/
    
}