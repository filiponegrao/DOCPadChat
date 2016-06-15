//
//  ChatView.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatView : UIView, ChatMessageBarDelegate
{
    private var messageBar : ChatMessageBar!
    
    private var imageView : UIImageView!
    
    private var titleView : UIView!
    
    private var channelLabel : UILabel!
    
    private var channelButton : UIButton!
    
    private var statusLabel : UILabel!
    
    weak private var controller : ChatController!
    
    /** Collection properties */
    
    var collectionView : UICollectionView!
    
    private var collectionOrigin : CGFloat!
    
    private var collectionHeight : CGFloat!
        
    init(frame: CGRect, controller: ChatController)
    {
        self.controller = controller
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.messageBar = ChatMessageBar(width: screenWidth)
        self.messageBar.delegate = self
        self.addSubview(self.messageBar)
        
        let height : CGFloat = self.controller.navigationController!.navigationBar.frame.size.height

        self.channelButton = UIButton(frame: CGRectMake(0,0,screenWidth/2, height))
        self.channelButton.setTitle("Filipo Negrao", forState: .Normal)
        self.channelButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        self.channelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.channelButton.addTarget(self.controller, action: #selector(self.controller.openGallery), forControlEvents: .TouchUpInside)
        
        self.controller.navigationItem.titleView = self.channelButton
        
        //Photo
        self.imageView = UIImageView(frame: CGRectMake(0, 0, height-5, height-5))
        self.imageView.image = UIImage(named: "channelTemplate")
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.clipsToBounds = true
        
        self.controller.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.imageView)
        
        
        //Collection
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        collectionLayout.itemSize = CGSize(width: frame.size.width, height: 60)
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        
        self.collectionOrigin = self.controller.navigationController!.navigationBar.frame.size.height + 10
        self.collectionHeight = self.frame.size.height - collectionOrigin - self.messageBar.frame.size.height
        
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, self.collectionOrigin, frame.size.width, self.collectionHeight) , collectionViewLayout: collectionLayout)
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.keyboardDismissMode = .Interactive
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.scrollEnabled = true
        self.collectionView.delegate = controller
        self.collectionView.dataSource = controller
        self.collectionView.canCancelContentTouches = false
        
        self.collectionView.registerClass(ChatTextCell.self, forCellWithReuseIdentifier: "CellText")
        
        self.addSubview(self.collectionView)
        
        //Notifications do TECLADO
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleKeyboardUp(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleKeyboardDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
//       self.messageBar.textView.endEditing(true)
    }
    
    func updateView(channel: Channel)
    {
        self.channelButton.setTitle(channel.name, forState: .Normal)
        self.imageView.image = UIImage(data: channel.image)
    }
    
    /*********************************/
    /********** ANIMATIONS ***********/
    /*********************************/
    
    func handleKeyboardUp(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.messageBar.frame.origin.y = screenHeight - keyboardSize.height - self.messageBar.frame.size.height
            self.collectionView.frame.size.height = self.collectionHeight - keyboardSize.height
            
            if(self.collectionView.contentSize.height > self.collectionView.frame.size.height)
            {
                if(self.collectionView.contentSize.height < self.collectionHeight)
                {
                    self.collectionView.contentOffset.y += self.collectionView.contentSize.height - keyboardSize.height
                }
                else
                {
                    self.collectionView.contentOffset.y += keyboardSize.height
                }
            }
        }
    }
    
    func handleKeyboardDown(notification: NSNotification)
    {
        self.messageBar.frame.origin.y = screenHeight - self.messageBar.frame.size.height
        self.collectionView.frame.size.height = self.collectionHeight
    }
    
    
    /*********************************/
    /*********************************/
    
    /*********************************/
    /**** MESSAGE BAR DELEGATE *******/
    /*********************************/
    
    func messageBarAudioClicked(messageBar: ChatMessageBar) {
        
        print("Audio clicked")
    }
    
    func messageBarPhotoClicked(messageBar: ChatMessageBar) {
        
        let sheet = UIAlertController(title: "Selecionar foto", message: nil, preferredStyle: .ActionSheet)
        
        sheet.addAction(UIAlertAction(title: "da Câmera", style: .Default, handler: { (action: UIAlertAction) in
            
        }))
        
        sheet.addAction(UIAlertAction(title: "do Álbum", style: .Default, handler: { (action: UIAlertAction) in
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        self.controller.presentViewController(sheet, animated: true) { 
            
        }
        
    }
    
    func messageBarSendClicked(messageBar: ChatMessageBar, text: String)
    {
        if(text != "")
        {
            ChatApplication.sharedInstance.sendMessage(000212, sender: 02, target: 01, text: text)
        }
        
    }
    
    /*********************************/
    /*********************************/
        
    func heightForImageCell() -> CGFloat
    {
        return 100;
    }
    
    func heightForAudioCell() -> CGFloat
    {
        return 60;
    }
    
    

}