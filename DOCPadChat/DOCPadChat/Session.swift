//
//  Session.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public enum SessionStatus : String
{
    case Friend
}


extension Session {
    
    @NSManaged var createdAt: NSDate!
    @NSManaged var id: NSNumber!
    @NSManaged var nickname: String!
    @NSManaged var profileImage: NSData!
    @NSManaged var status: String!
    @NSManaged var updatedAt: NSDate!
    
}

class Session: NSManagedObject {

    /**
     * Cria uma Sessao com foto.
     */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, nickname: String, profileImage: NSData) -> Session
    {
        
        let session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: moc) as! Session
        session.id = id
        session.nickname = nickname
        session.status = SessionStatus.Friend.rawValue
        session.createdAt = NSDate()
        session.updatedAt = NSDate()
        session.profileImage = profileImage
        
        return session
    }
    
    /**
     * Cria uma sessao sem foto.
     * Nesse caso é atribuida à Sessao ua imagem padrao.
     */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, nickname: String) -> Session
    {
        
        let session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: moc) as! Session
        session.id = id
        session.nickname = nickname
        session.status = SessionStatus.Friend.rawValue
        session.createdAt = NSDate()
        session.updatedAt = NSDate()
        session.profileImage = UIImage(named: "channelTemplate")!.highestQualityJPEGNSData
        
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
    
    func setImage(moc: NSManagedObjectContext, image: UIImage) -> Bool
    {
        self.profileImage = image.highestQualityJPEGNSData
        
        do
        {
            try moc.save()
            return true;
        }
        catch
        {
            print("Erro ao tentar atribuir uma imagem a um contato")
            return false
        }
    }
    
    func setImage(moc: NSManagedObjectContext, imageData image: NSData) -> Bool
    {
        self.profileImage = image
        
        do
        {
            try moc.save()
            return true
        }
        catch
        {
            print("Erro ao tentar atribuir uma imagem a um contato")
            return false
        }
    }
    
}
