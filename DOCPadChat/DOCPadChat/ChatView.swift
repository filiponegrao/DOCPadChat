//
//  ChatView.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class ChatView : UIView, ChatMessageBarDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate
{
    private var messageBar : ChatMessageBar!
    
    var imageView : UIImageView!
    
    private var titleView : UIView!
    
    private var channelLabel : UILabel!
    
    var channelButton : UIButton!
    
    private var statusLabel : UILabel!
    
    private var backgroundImage : UIImageView!
    
    weak private var controller : ChatController!
    
    private var sentImage : UIImage!
    
    private var editionButton : UIButton! //temp
    
    /** Collection properties */
    
    var collectionView : UICollectionView!
    
    private var collectionOrigin : CGFloat!
    
    private var collectionHeight : CGFloat!
    
    //sheet
    
    private var picker = UIImagePickerController()
    
//    private var popover : UIPopoverController!

    init(frame: CGRect, controller: ChatController)
    {
        self.controller = controller
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.backgroundImage = UIImageView(frame: self.bounds)
        self.backgroundImage.image = UIImage(named: "background")
        self.backgroundImage.contentMode = .ScaleToFill
        self.backgroundImage.alpha = 0.4
        self.addSubview(self.backgroundImage)
        
        self.messageBar = ChatMessageBar()
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
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionLayout.itemSize = CGSize(width: frame.size.width, height: 60)
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        
        self.collectionOrigin = 65
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
        self.collectionView.registerClass(ChatImageCell.self, forCellWithReuseIdentifier: "CellImage")
        self.collectionView.registerClass(ChatServerCell.self, forCellWithReuseIdentifier: "CellServer")
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        self.addSubview(self.collectionView)
        
        
        //teste para edicao
        
//        self.editionButton = UIButton(frame: CGRectMake(0,100,100,50))
//        self.editionButton.setTitle("Edition", forState: .Normal)
//        self.editionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        self.editionButton.addTarget(self.controller, action: #selector(ChatView.goEdition), forControlEvents: .TouchUpInside)
//        self.addSubview(self.editionButton)

        
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
    
    func disableMessages()
    {
        self.messageBar.textView.userInteractionEnabled = false
        self.messageBar.sendButton.enabled = false
        self.messageBar.audioButton.enabled = false
        self.messageBar.photoButton.enabled = false
    }
    
    func enableMessages()
    {
        self.messageBar.textView.userInteractionEnabled = true
        self.messageBar.sendButton.enabled = true
        self.messageBar.audioButton.enabled = true
        self.messageBar.photoButton.enabled = true
    }
    
    /*********************************/
    /********** ANIMATIONS ***********/
    /*********************************/
    
    func handleKeyboardUp(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.messageBar.frame.origin.y = screenHeight - keyboardSize.height - self.messageBar.frame.size.height
            
            self.collectionView.frame.size.height = self.frame.height - self.collectionOrigin - self.messageBar.frame.height - keyboardSize.height
            
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

        self.collectionView.frame.size.height = self.frame.size.height - self.collectionOrigin - self.messageBar.frame.height
    }
    
    
    /*********************************/
    /*********************************/
    
    /*********************************/
    /**** MESSAGE BAR DELEGATE *******/
    /*********************************/
 
    
    func messageBarStartAudioClicked(messageBar: ChatMessageBar)
    {
        AudioController.sharedInstance.startRecord()
    }
    
    func messageBarEndAudioClicked(messageBar: ChatMessageBar)
    {
        AudioController.sharedInstance.stopRecord()
    }
    
    func messageBarPhotoClicked(messageBar: ChatMessageBar)
    {
        let sheet = UIAlertController(title: "Selecionar foto", message: nil, preferredStyle: .ActionSheet)
        
        sheet.addAction(UIAlertAction(title: "da Câmera", style: .Default, handler: { (action: UIAlertAction) in
            
            self.openCamera()
        }))
        
        sheet.addAction(UIAlertAction(title: "do Álbum", style: .Default, handler: { (action: UIAlertAction) in
            
            self.openGallery()
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
            self.controller.sendTextMessage(text)
        }
        
        if !self.messageBar.textView.isFirstResponder()
        {
            self.messageBar.textView.placeHolderOn()
        }
    }
    
    func messageBarIncreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
    {
        UIView.animateWithDuration(0.3, animations: { 
            
            self.collectionView.frame.size.height -= plus
            self.collectionView.contentOffset.y += plus
            
        }) { (success: Bool) in
            
        }
    }
    
    func messageBarDecreasedSize(messageBar: ChatMessageBar, plus: CGFloat)
    {
        UIView.animateWithDuration(0.3, animations: {
            
            self.collectionView.frame.size.height += plus
            self.collectionView.contentOffset.y -= plus
            
        }) { (success: Bool) in
            
        }
    }
    
    /*********************************/
    /*********************************/
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraDevice = .Front
            self.picker.allowsEditing = true
            self.picker.delegate = self
            self.controller.presentViewController(self.picker, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    func openGallery()
    {
        self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.picker.delegate = self
        self.picker.allowsEditing = true
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone)
        {
            self.controller.presentViewController(self.picker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.picker.dismissViewControllerAnimated(true, completion: nil)
        
        ChatApplication.sharedInstance.sendImageMessage(nil, toContact: self.controller.usermodel.id, image: image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func heightForImageCell() -> CGFloat
    {
        return 100;
    }
    
    func heightForAudioCell() -> CGFloat
    {
        return 60;
    }
    
    //temp
    func goEdition()
    {
//        let img = UIImage(named: "gamba")
//        let viewController = ImageEditionController(image: img)
//        self.controller.navigationController?.pushViewController(viewController, animated: true)
    }

}