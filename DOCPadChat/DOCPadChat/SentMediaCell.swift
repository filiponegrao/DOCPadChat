//
//  SentMediaCell.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 01/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class SentMediaCell: UICollectionViewCell
{
    var image : UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.image = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.image.contentMode = .ScaleAspectFill
        self.image.clipsToBounds = true
        self.addSubview(self.image)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
