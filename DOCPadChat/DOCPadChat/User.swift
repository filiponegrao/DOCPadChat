//
//  User.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 28/04/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData


extension User {
    
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var email: String!
    @NSManaged var gender: String?
    @NSManaged var id: NSNumber!
    @NSManaged var password: String!
    @NSManaged var profileImage: NSData?
    @NSManaged var username: String!
    
}

class User: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, username: String, email: String, password: String, gender: String?, country: String?, city: String?) -> User
    {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
        
        user.id = id
        user.username = username
        user.email = email
        user.password = password
        user.gender = gender
        user.country = country
        user.city = city
        user.createdAt = NSDate()
        
        return user
    }
}


