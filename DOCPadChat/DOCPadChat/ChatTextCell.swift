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
        self.textLabel.contentInset = UIEdgeInsetsMake(0, 5, 0, 0)
        self.textLabel.layer.borderWidth = 0.3
        self.textLabel.layer.borderColor = UIColor.grayColor().CGColor
        
  
        
        self.dateLabel = UILabel(frame: CGRectMake(0,0,40,20))
        self.dateLabel.text = "28/09"
        self.dateLabel.font = UIFont(name: "Helvetica", size: 12)
        self.dateLabel.textColor = GMColor.grey500Color()
        self.dateLabel.frame.size.height = dateHeight
//        self.dateLabel.layer.borderWidth = 1
    }
    
    func configureCell(message: Message)
    {
        if let id = ChatApplication.sharedInstance.getId()
        {
            //Usuario corrente enviou a mensagem
            if message.sender == id
            {
                self.dateLabel?.removeFromSuperview()
                self.dateLabel.text = UseFulFunctions.getStringDateFromDate(message.sentDate)
                let dateorigin = screenWidth - (self.textLabel.frame.size.width + cellMarginH*2 + self.dateLabel.frame.width)
                self.dateLabel.frame.origin.x = dateorigin
                self.dateLabel.frame.origin.y = self.frame.height - dateHeight - cellMarginV
                self.addSubview(self.dateLabel)
                
                
                self.textLabel?.removeFromSuperview()
                self.textLabel.text = message.text
                self.textLabel.frame.size = CGSizeMake(maxTextCellWidth, 60)
                self.textLabel.frame.size = CGSizeMake(self.textLabel.contentSize.width + cellMarginH*2, self.textLabel.contentSize.height)
                self.textLabel.sizeToFit()
                self.textLabel.frame.size.height += dateHeight
                self.textLabel.frame.size.width += cellMarginH
                let textorigin = screenWidth - (self.textLabel.frame.size.width + cellMarginH)
                self.textLabel.frame.origin.x = textorigin
                self.textLabel.frame.origin.y = cellMarginV
                self.textLabel.backgroundColor = GMColor.grey400Color()

                self.addSubview(self.textLabel)
                
                if(self.textLabel.frame.width < 40 + cellMarginH)
                {
                    let dif = (40+cellMarginH) - (self.textLabel.frame.width)
                    self.textLabel.frame.origin.x -= dif
                    self.textLabel.frame.size.width += dif
                }
                
                //Ajeitando posicoes
                
                self.bringSubviewToFront(self.dateLabel)

                self.dateLabel.frame.origin.y = self.frame.size.height - cellMarginV*2 - self.dateLabel.frame.height
                self.dateLabel.frame.origin.x = screenWidth - self.dateLabel.frame.size.width - cellMarginH
            }
            //Usuario corrente nao enviou a mensagem
            else
            {
                self.dateLabel?.removeFromSuperview()
                self.dateLabel.text = UseFulFunctions.getStringDateFromDate(message.sentDate)
                let dateorigin = cellMarginH
                self.dateLabel.frame.origin.x = dateorigin
                self.dateLabel.frame.origin.y = self.frame.height - dateHeight - cellMarginV
                self.addSubview(self.dateLabel)
                
                self.textLabel?.removeFromSuperview()
                self.textLabel.text = message.text
                self.textLabel.frame.size = CGSizeMake(maxTextCellWidth, 60)
                self.textLabel.frame.size = CGSizeMake(self.textLabel.contentSize.width + cellMarginH*2, self.textLabel.contentSize.height)
                self.textLabel.sizeToFit()
                self.textLabel.frame.size.height += dateHeight
                self.textLabel.frame.size.width += cellMarginH
                let textorigin = cellMarginH
                self.textLabel.frame.origin.x = textorigin
                self.textLabel.frame.origin.y = cellMarginV
                self.textLabel.backgroundColor = GMColor.grey50Color()
                self.addSubview(self.textLabel)

                if(self.textLabel.frame.width < 40 + cellMarginH)
                {
                    let dif = (40+cellMarginH) - (self.textLabel.frame.width)
                    self.textLabel.frame.size.width += dif
                }
                
                //Ajeitando posicoes
                
                self.bringSubviewToFront(self.dateLabel)
                
                self.dateLabel.frame.origin.y = self.frame.size.height - cellMarginV*2 - self.dateLabel.frame.height
                self.dateLabel.frame.origin.x = cellMarginH*2
            }
        }
    }
    
    class func getHeightForCell(forMessage message: Message) -> CGFloat
    {
        let textview = UITextView(frame: CGRectMake(0, 0, maxTextCellWidth, 100))
        
        textview.font = defaultFont
        textview.text = message.text
        
        return (textview.contentSize.height) + cellMarginV*2 + dateHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
