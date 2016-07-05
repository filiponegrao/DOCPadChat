//
//  ImageEditionView.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 05/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ImageEditionView: UIView
{
    var imageView : UIImageView!
    
    var collection : UICollectionView!
    
    weak private var controller : ImageEditionController!
    
    init(image: UIImage, controller: ImageEditionController)
    {
        self.controller = controller
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight-70))
        
        self.backgroundColor = UIColor.whiteColor()
        
//        let nav = self.controller.navigationController!.navigationBar
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight/10 * 5.5))
        self.imageView.image = image
        self.imageView.contentMode = .ScaleAspectFit
        
        self.imageView.backgroundColor = UIColor.clearColor()
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.addSubview(self.imageView)
        
        //Navigation
        
        let right = UIBarButtonItem(title: "Enviar", style: .Plain, target: controller, action: #selector(self.controller.sendImage))
        self.controller.navigationItem.rightBarButtonItem = right
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }


}
