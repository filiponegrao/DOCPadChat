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
        
        self.view = UIImageView(frame: CGRectMake(0, cellMarginV, imageCellWidth, imageCellHeight - cellMarginV*2))
        self.view.backgroundColor = GMColor.grey300Color()
        self.view.layer.cornerRadius = 8
        self.view.clipsToBounds = true
        self.addSubview(self.view)
        
        self.dateLabel = UILabel(frame: CGRectMake(0,0,40,20))
        self.dateLabel.text = "66/66"
        self.dateLabel.font = UIFont(name: "Helvetica", size: 12)
        self.dateLabel.textColor = GMColor.grey500Color()
        self.view.addSubview(self.dateLabel)
        
        self.imageView = UIImageView(frame: CGRectMake(cellMarginH, cellMarginV, self.view.frame.size.width - cellMarginH*2, self.view.frame.size.height - cellMarginV*2))
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
