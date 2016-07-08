//
//  SentMediaController.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class SentMediaController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    private var sentView : SentMediaView!
    
    private var sentMessages : [Message]!
    
    private var userModel : UserModel!
    
    init(userModel : UserModel)
    {
        self.userModel = userModel
        
        self.sentMessages = DAOMessage.sharedInstance.getMessagesWithContent(self.userModel.id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.sentView = SentMediaView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70), controller: self)
        self.sentView.collection.delegate = self
        self.sentView.collection.dataSource = self
        self.sentView.collection.registerClass(SentMediaCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.view.addSubview(self.sentView)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*********************************/
    /****** COLLECTION DELEGATE ******/
    /*********************************/
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.sentMessages.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let message = self.sentMessages[indexPath.item]

        let image = UIImage(data: message.file!.content)

        if(image != nil)
        {
            let sentImageView = SentImageView(image: image!, message: message, requester: self)
            self.navigationController?.view.addSubview(sentImageView)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SentMediaCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.image.image = UIImage(data: self.sentMessages[indexPath.item].file!.content)
        
        return cell
    }
    
    /*********************************/
    /********** FIM DELEGATE *********/
    /*********************************/
    
    func deleteAll()
    {
//        deleteAllMessageContentsSentTo
    }
}
