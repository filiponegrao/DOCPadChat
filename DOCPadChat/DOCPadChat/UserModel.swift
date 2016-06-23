//
//  UserModel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 16/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class UserModel
{
    var id : String!
    
    var name : String!
    
    var profileImage : UIImage!
    
    init(id: String, name: String, profileImage: UIImage)
    {
        self.id = id
        self.name = name
        self.profileImage = profileImage
    }
}