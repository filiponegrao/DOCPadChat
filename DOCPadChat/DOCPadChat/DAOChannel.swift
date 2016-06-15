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
    
    /**
     * Novo canal entre duas pessoas.
     */
    func newChannel(id: Int, session: Session) -> Channel?
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            if results.count != 0 { return nil }
            
            let channel = Channel.createInManagedObjectContext(self.managedObjectContext, id: id, session: session)
            
            self.save()
            
            return channel
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * Novo canal de grupo.
     */
    func newChannel(id: Int, sessions: [Session], name: String, author: Int) -> Channel?
    {
        let query = NSFetchRequest(entityName: "Channel")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Channel]
            
            if results.count != 0 { return nil }
            
            let channel = Channel.createInManagedObjectContext(self.managedObjectContext, id: id, name: name, author: author, sessions: sessions)
            
            self.save()
            
            return channel
        }
        catch
        {
            return nil
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

    /**
     * Recupera um canal do tipo conversa entre duas pessoas,
     * dado o numero de sessao do outro contato.
     */
    func getSingleChannelFromSession(session: Int) -> Channel?
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
    
    func addSessionToChannel(id: Int, session: Session) -> Bool
    {
        if let channel = DAOChannel.sharedInstance.getChannel(id)
        {
            if channel.type == ChannelType.Single.rawValue
            {
                return channel.addSessionToSingleChannel(session, moc: self.managedObjectContext)
            }
            else if channel.type == ChannelType.Group.rawValue
            {
                return channel.addSessionsToGroupChannel([session], moc: self.managedObjectContext)
            }
        }
        
        return false
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