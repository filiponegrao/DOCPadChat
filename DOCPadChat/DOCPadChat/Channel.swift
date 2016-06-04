//
//  Channel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData


public enum ChannelType : String
{
    case Single = "single"
    
    case Group = "group"
}

extension Channel {
    
    @NSManaged var author: NSNumber!
    @NSManaged var createdAt: NSDate!
    @NSManaged var id: NSNumber!
    @NSManaged var image: NSData!
    @NSManaged var name: String!
    @NSManaged var type: String!
    @NSManaged var updatedAt: NSDate!
    @NSManaged var sessions: NSSet?
    
}

class Channel: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, createdAt: NSDate, image: NSData?, author: Int, name: String, type: ChannelType) -> Channel
    {
        let channel = NSEntityDescription.insertNewObjectForEntityForName("Channel", inManagedObjectContext: moc) as! Channel
        
        channel.author = author;
        channel.createdAt = createdAt;
        channel.id = id;
        channel.sessions = NSSet.init(array: [Session]())
        channel.type = type.rawValue;
        channel.updatedAt = NSDate();
        
        if type == ChannelType.Single
        {
            channel.name = "Enpty Chat"
        }
        else
        {
            channel.name = name
        }
        
        return channel
    }
    
    func getSessionFromSingleChannel() -> Session?
    {
        if self.type == ChannelType.Single.rawValue
        {
            if let sessions = self.sessions?.allObjects as? [Session]
            {
                return sessions.first
            }
        }
        
        return nil
    }
    
    func getSessionsFromGroupChannel() -> [Session]?
    {
        if self.type == ChannelType.Group.rawValue
        {
            if let sessions = self.sessions?.allObjects as? [Session]
            {
                return sessions
            }
            
            return nil
        }
        
        return nil
    }
    
    func addSessionToSingleChannel(session: Session) -> Bool
    {
        if self.type != ChannelType.Single.rawValue { return false }
        
        if var currentSessions = self.sessions?.allObjects as? [Session]
        {
            if currentSessions.count != 0 { return false }
            
            currentSessions.append(session)
            
            self.sessions = NSSet.init(array: [currentSessions])
            do
            {
                try self.managedObjectContext?.save()
                return true
                
            }
            catch
            {
                "Nao foi possivel adicionar \(session.nickname) ao Canal"
                return false
            }
        }
        
        return false
    }
    
    func addSessionsToGroupChannel(sessions: [Session]) -> Bool
    {
        if self.type == ChannelType.Single.rawValue { return false }
        
        if var currentSessions = self.sessions?.allObjects as? [Session]
        {
            for s in sessions
            {
                if !self.isAlreadyMember(s)
                {
                    currentSessions.append(s)
                }
            }
            
            self.sessions = NSSet.init(array: currentSessions)
            do
            {
                try self.managedObjectContext?.save()
                return true
            }
            catch
            {
                "Nao foi possivel adicionar as sessoes ao grupo \(self.name)"
                return false
            }
        }
        
        return false
    }
    
    func isAlreadyMember(session: Session) -> Bool
    {
        if let currentSessions = self.sessions?.allObjects as? [Session]
        {
            for s in currentSessions
            {
                if session.id == s.id
                {
                    return true
                }
            }
            
            return false
        }
        
        return false
    }

}
