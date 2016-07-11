//
//  ChatController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RecorderDelegate
{
    /******* Chat Variables *********/

//    private var channel : Channel!
    
    var usermodel : UserModel!
    
    private var messages: [Message] = [Message]()
    
    private var chatView : ChatView!
        
    /********************************/
    
    var leftButton : UIBarButtonItem!
    
    var rightButton : UIBarButtonItem!
    
    var button : UIButton!
    
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
    

    func refreshChat()
    {
        if let id = ChatApplication.sharedInstance.getId()
        {
            self.messages = DAOMessage.sharedInstance.getMessagesWithContact(id, contact: self.usermodel.id)
            self.chatView.collectionView.reloadData()
            
            self.chatView.imageView.image = self.usermodel.profileImage
            self.chatView.channelButton.setTitle(self.usermodel.name, forState: .Normal)
            
            if(self.messages.count > 0)
            {
                self.chatView.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: self.messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: false)
                self.chatView.collectionView.contentOffset.y += 10
            }
        }
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
        self.registerNotifications()
        self.handleOffline(nil)
        
        AudioController.sharedInstance.recorderDelegate = self
    }
    
    func registerNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNewMessage(_:)), name: Event.message_new.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleOnline(_:)), name: Event.app_connected.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleTimedOut(_:)), name: Event.app_timeout.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleConnecting(_:)), name: Event.app_connecting.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleOffline(_:)), name: Event.app_disconnected.rawValue, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.refreshChat()
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
        let sentMediaController = SentMediaController(userModel: self.usermodel)
        self.navigationController?.pushViewController(sentMediaController, animated: true)
    }
    
    func openImage(message: Message)
    {
        let receivedImageController = ReceivedImageController(message: message, requester: self)
        
        self.navigationController?.pushViewController(receivedImageController, animated: true)
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
        else if message.type == MessageType.Image.rawValue
        {
            let height = imageCellHeight
            
            return CGSizeMake(screenWidth, height)
        }
        else if message.type == MessageType.Audio.rawValue
        {
            return CGSizeMake(screenWidth, audioCellHeight)
        }
        else if message.type == MessageType.Server.rawValue
        {
            return CGSizeMake(screenWidth, serverCellHeight)
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
        let message = self.messages[indexPath.item]
        
        let type = message.type

        if(type == MessageType.Image.rawValue)
        {
            let image = UIImage(data: message.file!.content)
            if(image != nil)
            {
                self.openImage(message)
            }
        }
        
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
        else if (type == MessageType.Image.rawValue)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! ChatImageCell
            
            if let file = message.file
            {
                let data = file.content
                
                let image = UIImage(data: data)
                
                cell.imageView.image = image
                
                cell.configureCell(message)
            }
            
            return cell
        }
        else if type == MessageType.Audio.rawValue
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellAudio", forIndexPath: indexPath) as! ChatAudioCell

            cell.configureCell(message)

            return cell
        }
        else if type == MessageType.Server.rawValue
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellServer", forIndexPath: indexPath) as! ChatServerCell
            
            cell.configureCell(self.usermodel.name, date: message.sentDate)
            
            return cell
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    }
    
    
    /********************************/
    /*********** HANDLERS  **********/
    /********************************/

    func handleNewMessage(notification: NSNotification)
    {
        if let userinfo = notification.userInfo
        {
            let message = userinfo["message"] as! Message
            let sender = message.sender
            
            //Verifica se o remetente é o mesmo
            if sender != self.usermodel.id && sender != ChatApplication.sharedInstance.getId() { return }
            
            self.messages = DAOMessage.sharedInstance.getMessagesWithContact(ChatApplication.sharedInstance.getId()!, contact: self.usermodel.id)

            if let index = self.messages.indexOf(message)
            {
                let indexPath = NSIndexPath.init(forItem: index, inSection: 0)
                self.chatView.collectionView.insertItemsAtIndexPaths([indexPath])
                self.chatView.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: self.messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
            }
            else
            {
                self.chatView.collectionView.reloadData()
            }
        }
    }
    
    func handleOnline(notification: NSNotification?)
    {
        self.chatView.channelButton.setTitle(self.usermodel.name, forState: .Normal)
        self.chatView.enableMessages()
    }
    
    func handleOffline(notification: NSNotification?)
    {
        if let userinfo = notification?.userInfo
        {
            let error = userinfo["error"] as! NSError
            print(error)
        }
        
        self.chatView.channelButton.setTitle("Desconectado", forState: .Normal)
        self.chatView.disableMessages()
    }
    
    func handleNoInternet()
    {
        self.chatView.channelButton.setTitle("Desconectado", forState: .Normal)
        self.chatView.disableMessages()
        
        let alert = UIAlertController(title: "Ops!", message: "Parece que voce nao tem uma conexao com a internet! Verifique e abra essa tela novamente", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action: UIAlertAction) in
            
        }))
        self.presentViewController(alert, animated: true, completion: { 
            
        })
    }
    
    func handleConnecting(notification: NSNotification)
    {
        self.chatView.channelButton.setTitle("Conectando...", forState: .Normal)
        self.chatView.disableMessages()
    }
    
    func handleTimedOut(notitifation: NSNotification)
    {
        self.chatView.channelButton.setTitle("Desconectado", forState: .Normal)
        self.chatView.disableMessages()
    }
    
    func sendTextMessage(text: String)
    {
        ChatApplication.sharedInstance.sendTextMessage(text, toContact: self.usermodel.id)
    }

    
    /********************************/
    /********************************/
    
    /*********************************/
    /******** AUDIO DELEGATES ********/
    /*********************************/
    
    func audioEndPlaying()
    {
        
    }
    
    func audioRecorded(audio: NSData)
    {
        ChatApplication.sharedInstance.sendAudioMessage(nil, toContact: self.usermodel.id, audio: audio)
    }
    
    /********************************/
    /********************************/
    
    
    
}