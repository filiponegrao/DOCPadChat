//
//  ChatTextCell.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 14/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ChatServerCell: UICollectionViewCell
{
    private var textLabel : UITextView!
    
    private var dateLabel : UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.textLabel = UITextView(frame: CGRectMake(cellMarginH*4, cellMarginV, self.frame.width - cellMarginH*8, self.frame.size.height - 2*cellMarginV))
        self.textLabel.text = "Fulaninho efetuou uma captura de tela na imagem na qual voce enviou!"
        self.textLabel.backgroundColor = GMColor.orange100Color()
        self.textLabel.layer.cornerRadius = 8
        self.textLabel.clipsToBounds = true
        self.textLabel.font = defaultFont
        self.textLabel.textColor = GMColor.grey700Color()
        self.textLabel.userInteractionEnabled = false
        self.textLabel.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.textLabel.layer.borderWidth = 0.3
        self.textLabel.layer.borderColor = UIColor.grayColor().CGColor
        self.addSubview(self.textLabel)
        
        self.dateLabel = UILabel(frame: CGRectMake(self.textLabel.frame.width - 40, self.frame.height - 25 , 40, 20))
        self.dateLabel.text = "28/09"
        self.dateLabel.font = UIFont(name: "Helvetica", size: 12)
        self.dateLabel.textColor = GMColor.grey700Color()
        self.dateLabel.frame.size.height = dateHeight
        self.textLabel.addSubview(self.dateLabel)
//        self.dateLabel.layer.borderWidth = 1
    }

    func configureCell(contactUsername: String, date: NSDate)
    {
        self.textLabel.text = "\(contactUsername) efetuou uma captura de tela da imagem na qual voce enviou!"
        self.dateLabel.text = UseFulFunctions.getStringDateFromDate(date)
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
