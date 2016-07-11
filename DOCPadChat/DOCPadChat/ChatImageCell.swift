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
    
    var message : Message!
    
    var blurView : UIVisualEffectView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.view = UIImageView(frame: CGRectMake(0, cellMarginV, imageCellWidth - cellMarginH*2, imageCellHeight - cellMarginV*2))
        self.view.backgroundColor = GMColor.grey200Color()
        self.view.layer.cornerRadius = 8
        self.view.clipsToBounds = true
        self.view.layer.borderWidth = 0.3
        self.view.layer.borderColor = UIColor.grayColor().CGColor
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(1, 2.0)
        self.view.layer.shadowRadius = 2.0
        self.view.layer.shadowOpacity = 0.2
        self.view.layer.masksToBounds = false
        self.view.layer.shadowPath = UIBezierPath(roundedRect: self.view.bounds, cornerRadius: self.view.layer.cornerRadius).CGPath
        self.addSubview(self.view)
        
        self.dateLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2  - cellMarginH, self.view.frame.size.height - 20,self.view.frame.size.width/2, 15))
        self.dateLabel.text = "66/66"
        self.dateLabel.font = UIFont(name: "Helvetica", size: 11)
        self.dateLabel.textColor = GMColor.grey600Color()
        self.dateLabel.textAlignment = .Right
        self.view.addSubview(self.dateLabel)
        
        self.imageView = UIImageView(frame: CGRectMake(cellMarginH, cellMarginH, self.view.frame.size.width - cellMarginH*2, self.view.frame.size.height - cellMarginH*2 - self.dateLabel.frame.size.height))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.layer.cornerRadius = 8
        self.imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
        self.blurView.frame = self.imageView.bounds
        self.blurView.alpha = 0.97
        self.imageView.addSubview(self.blurView)
    }
    
    func configureCell(message: Message)
    {
        self.message = message
        
        self.dateLabel.text = UseFulFunctions.getStringDateFromDate(self.message.sentDate)
        
        if let id = ChatApplication.sharedInstance.getId()
        {
            //se é usuário corrente o sender
            if(message.sender == id)
            {
                self.view.frame.origin.x = screenWidth - self.view.frame.size.width - cellMarginH
                self.view.backgroundColor = GMColor.grey300Color()
                self.dateLabel.textColor = GMColor.grey700Color()

            }
            else
            {
                self.view.backgroundColor = GMColor.grey200Color()
                self.view.frame.origin.x = cellMarginH
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
