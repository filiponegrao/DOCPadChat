//
//  SentMediaView.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class SentMediaView: UIView
{
    var collection : UICollectionView!
    
    weak private var controller : SentMediaController!
    
    init(frame: CGRect, controller : SentMediaController)
    {
        self.controller = controller
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: screenWidth/3 - 5)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeZero
        
        let nav = self.controller.navigationController!.navigationBar
        
        let navLimit = nav.frame.origin.y + nav.frame.size.height
        
        self.collection = UICollectionView(frame: CGRectMake(0, 0, screenWidth, screenHeight - 70) , collectionViewLayout: layout)
        self.collection.backgroundColor = UIColor.clearColor()
        self.collection.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0)
        self.collection.showsVerticalScrollIndicator = false
        self.addSubview(self.collection)
        
        
        //Navigation
        
        let right = UIBarButtonItem(title: "Apagar tudo", style: .Plain, target: controller, action: #selector(self.controller.deleteAll))
        self.controller.navigationItem.rightBarButtonItem = right
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
