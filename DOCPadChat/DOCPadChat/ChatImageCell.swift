//
//  ChatImageCell.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 23/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ChatImageCell: UICollectionViewCell
{
    private var view : UIView!
    
    var imageView : UIImageView!
    
    private var dateLabel : UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.view = UIImageView(frame: CGRectMake(0, cellMarginV, imageCellWidth, imageCellHeight))
        self.view.backgroundColor = GMColor.grey300Color()
        self.view.layer.cornerRadius = 8
        self.view.clipsToBounds = true
        self.addSubview(self.view)
        
        self.imageView = UIImageView(frame: CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 30))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.layer.cornerRadius = 8
        self.imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        
    }
    
    func configureCell(message: Message)
    {
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
