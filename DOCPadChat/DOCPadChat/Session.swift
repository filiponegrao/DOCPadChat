//
//  Session.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData

public enum SessionStatus : String
{
    case Friend
}

extension Session {
    
    @NSManaged var createdAt: NSDate!
    @NSManaged var id: NSNumber!
    @NSManaged var nickname: String!
    @NSManaged var profileImage: NSData?
    @NSManaged var status: String!
    @NSManaged var updatedAt: NSDate!
    
}

class Session: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, nickname: String, profileImage: NSData?) -> Session
    {
        
        let session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: moc) as! Session
        session.id = id
        session.nickname = nickname
        session.status = SessionStatus.Friend.rawValue
        session.createdAt = NSDate()
        session.updatedAt = NSDate()
        
        return session
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let id = self.id { aCoder.encodeObject(id, forKey: "id") }
        if let status = self.status { aCoder.encodeObject(status, forKey: "status") }
        if let nickname = self.nickname { aCoder.encodeObject(nickname, forKey: "nickname") }
        if let createdAt = self.createdAt { aCoder.encodeObject(createdAt, forKey: "createdAt") }
        if let updatedAt = self.updatedAt { aCoder.encodeObject(updatedAt, forKey: "updatedAt") }
        if let profileImage = self.profileImage { aCoder.encodeObject(profileImage, forKey: "profileImage") }
    }
    
    required convenience init(coder decoder: NSCoder) {
        
        self.init()
        
        self.id = decoder.decodeObjectForKey("id") as! NSNumber
        self.nickname = decoder.decodeObjectForKey("nickname") as! String
        self.createdAt = decoder.decodeObjectForKey("createdAt") as! NSDate
        self.updatedAt = decoder.decodeObjectForKey("updatedAt") as! NSDate
        self.profileImage = decoder.decodeObjectForKey("profileImage") as? NSData
        self.status = decoder.decodeObjectForKey("status") as! String
    }
    
}
