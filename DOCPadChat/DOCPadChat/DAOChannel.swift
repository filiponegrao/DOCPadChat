//
//  DAOChannel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data : DAOChannel = DAOChannel()

class DAOChannel : NSObject
{
    
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    class var sharedInstance : DAOChannel {
        
        return data
    }
    
    
    func newChannel(id: Int, type: ChannelType, author: Int, name: String) -> Channel?
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            if results.count != 0 { return nil }
            
            let channel = Channel.createInManagedObjectContext(self.managedObjectContext, id: id, createdAt: NSDate(), image: UIImage(named: "channelTemplate")!.highestQualityJPEGNSData, author: author, name: name, type: type)
            
            self.save()
            
            return channel
        }
        catch
        {
            return nil
        }
    }
    
    func addSessionChannel(channel: Channel, session: Session) -> Bool
    {
        if let user = DAOUser.sharedInstance.getCurrentUser()
        {
            if session.id == user.id
            {
                return false
            }
        }
        
        if channel.type == ChannelType.Single.rawValue
        {
            if channel.addSessionToSingleChannel(session)
            {
                return true
            }
            else { return false }
        }
        else if channel.type == ChannelType.Group.rawValue
        {
            if channel.addSessionsToGroupChannel([session])
            {
                return true
            }
            else { return false }
        }
        
        return false
    }
    

    
    func addSessionToGroup(group: Int, session: Session) -> Bool
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: group))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            if results.count == 0 { return false }
            
            if let channel = results.first
            {
                if channel.addSessionsToGroupChannel([session])
                {
                    return true
                }
                else { return false }
            }
            
            return false
        }
        catch
        {
            return false
        }
    }
    
    func getChannels() -> [Channel]
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        do { return try self.managedObjectContext.executeFetchRequest(query) as! [Channel]}
        catch { return [Channel]() }
    }

    func getChannel(id: Int) -> Channel?
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            return results.first
        }
        catch
        {
            return nil
        }
    }

    func getChannelFromSession(session: Int) -> Channel?
    {
        for c in self.getChannels()
        {
            if let s = c.getSessionFromSingleChannel()
            {
                if Int(s.id) == session
                {
                    return c
                }
            }
        }
        
        return nil
    }
    
    func setChannelName(id: Int, name: String) -> Bool
    {
        if let channel = self.getChannel(id)
        {
            channel.name = name
            self.save()
            
            return true
        }
        
        return false
    }
    
    func deleteChannel(id: Int) -> Int?
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            for i in 0..<results.count
            {
                if Int(results[i].id) == id
                {
                    self.managedObjectContext.deleteObject(results[i])
                    self.save()
                    
                    return i
                }
            }
            
            return nil
        }
        catch
        {
            return nil
        }
    }
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
}