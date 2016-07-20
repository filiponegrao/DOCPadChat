//
//  ImageEditionCell.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 06/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ImageEditionCell: UICollectionViewCell
{
    var imageView : UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth/6, screenWidth/6))
//        self.imageView.backgroundColor = UIColor.redColor()
        self.addSubview(self.imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
