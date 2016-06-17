//
//  UserModel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 16/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation

class UserModel
{
    var id : String!
    
    var name : String!
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
    }
}