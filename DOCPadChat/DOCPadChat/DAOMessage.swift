//
//  DAOMessage.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 04/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data : DAOMessage = DAOMessage()

class DAOMessage : NSObject
{
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    class var sharedInstance : DAOMessage {
        
        return data
    }
    

    func newMessage(id: String, sender: String, target: String, type: MessageType, sentDate: NSDate, text: String) -> Message?
    {
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            if results.count != 0 { return nil }
            
            let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: sender, target: target, text: text, type: type, sentDate: sentDate)
            
            self.save()
            
            return message
        }
        catch
        {
            return nil
        }
    }
    
    func getMessage(id: String) -> Message?
    {
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            return results.first
        }
        catch
        {
            return nil
        }
    }
    
    func getMessagesFromChannel(channel: String) -> [Message]
    {
        let mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", channel)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            return results
        }
        catch
        {
            return mssgs
        }
    }
    
    func getRecentMessagesFromChannel(channel: String) -> [Message]
    {
        var mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", channel)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            let calendar = NSCalendar.currentCalendar()
            
            let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])

            for message in results
            {
                if(message.sentDate.isGreaterThanDate(yesterday!))
                {
                    mssgs.append(message)
                }
            }
            
            return mssgs
        }
        catch
        {
            return mssgs
        }
    }
    
    func getMessagesFrom(id: String) -> [Message]
    {
        let messages = [Message]()
        
        do { return try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Message")) as! [Message] }
            
        catch {}
        
        return messages
    }
    
    func getOldMessagesFromChannel(channel: String) -> [Message]
    {
        var mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", channel)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            let calendar = NSCalendar.currentCalendar()
            
            let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
            
            for message in results
            {
                if(message.sentDate.isLessThanDate(yesterday!))
                {
                    mssgs.append(message)
                }
            }
            
            return mssgs
        }
        catch
        {
            return mssgs
        }
    }
    
    /** 
     * Se deletada com sucesso, o método retorna o index
     * da mensagem em questao referente às outras mensagens
     * do mesmo canal.
     */
    func deleteMessage(id: String) -> Int?
    {
        if let message = self.getMessage(id)
        {
            let messages = self.getMessagesFromChannel(message.target)
            
            let index = messages.indexOf(message)!
            
            self.managedObjectContext.deleteObject(message)
            
            self.save()
            
            return index
        }
        
        return nil
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