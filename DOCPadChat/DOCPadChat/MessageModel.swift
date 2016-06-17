//
//  MessageModel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 16/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

struct MessageModel
{
    var messageBody : String!
    var messageSender : String!
    var messageTimeStamp : String!
    
    init(body : String!, sender : String!, timestamp : String!)
    {
        messageBody = body
        messageSender = sender
        messageTimeStamp = timestamp
    }
}