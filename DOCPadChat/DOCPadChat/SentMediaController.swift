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
    weak var navBar : MainNavigationController!
    
    private var sentView : SentMediaView!
    
    var image = UIImage(named: "gamba") //temp

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navBar = MainNavigationController()
        
        self.sentView = SentMediaView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let sentImageView = SentImageView(image: self.image!, requester: self)
        self.navigationController?.view.addSubview(sentImageView)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SentMediaCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.image.image = self.image
        
        return cell
    }
    
    /*********************************/
    /********** FIM DELEGATE *********/
    /*********************************/
}
