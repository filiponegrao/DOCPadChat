//
//  ChatTextCell.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 14/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ChatTextCell: UICollectionViewCell
{
    
    private var textLabel : UITextView!
    
    private var dateLabel : UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.textLabel = UITextView(frame: CGRectMake(0, cellMarginV, maxTextCellWidth, self.frame.size.height - 2*cellMarginV))
        self.textLabel.text = "Valar Morgulis"
        self.textLabel.backgroundColor = GMColor.grey300Color()
        self.textLabel.layer.cornerRadius = 8
        self.textLabel.clipsToBounds = true
        self.textLabel.font = defaultFont
        self.textLabel.textColor = defaultTextColor
        self.textLabel.userInteractionEnabled = false
        
        self.dateLabel = UILabel(frame: CGRectMake(0,0,100,80))
        self.dateLabel.text = "28/09"
        self.dateLabel.font = UIFont(name: "Gill Sans", size: 13)
        self.dateLabel.textColor = GMColor.grey500Color()
    }
    
    func configureCell(message: Message)
    {
        print("eu eu eu eu")
        if let id = ChatApplication.sharedInstance.getId()
        {
            //Usuario corrente enviou a mensagem
            if message.sender == id
            {
                self.textLabel?.removeFromSuperview()
                self.textLabel.text = message.text
                self.textLabel.frame.size = CGSizeMake(maxTextCellWidth, 60)
                self.textLabel.frame.size = CGSizeMake(self.textLabel.contentSize.width, self.textLabel.contentSize.height)
                self.textLabel.sizeToFit()
                let textorigin = screenWidth - (self.textLabel.frame.size.width + cellMarginH)
                self.textLabel.frame.origin.x = textorigin
                self.textLabel.frame.origin.y = cellMarginV
                self.addSubview(self.textLabel)
                

                self.dateLabel?.removeFromSuperview()
                self.dateLabel.text = UseFulFunctions.getStringDateFromDate(message.sentDate)
                self.dateLabel.sizeToFit()
                let dateorigin = screenWidth - (self.textLabel.frame.size.width + cellMarginH*2 + self.dateLabel.frame.width)
                self.dateLabel.frame.origin.x = dateorigin
                self.dateLabel.frame.origin.y = self.textLabel.frame.origin.y + self.textLabel.frame.height - self.dateLabel.frame.height
                self.addSubview(self.dateLabel)

            }
            //Usuario corrente nao enviou a mensagem
            else
            {
                
            }
        }
    }
    
    class func getHeightForCell(forMessage message: Message) -> CGFloat
    {
        let textview = UITextView(frame: CGRectMake(0, 0, maxTextCellWidth, 100))
        
        textview.font = defaultFont
        textview.text = message.text
        
        return (textview.contentSize.height + cellMarginV*2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
