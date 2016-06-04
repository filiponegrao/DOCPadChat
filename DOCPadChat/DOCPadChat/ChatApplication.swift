//
//  ChatApplication.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

private let data : ChatApplication = ChatApplication()

class ChatApplication : NSObject
{
    class var sharedInstance : ChatApplication {
        
        return data
    }
    
    
}