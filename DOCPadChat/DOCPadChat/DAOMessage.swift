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
    

    func newMessage(id: Int, sender: Int, target: Int, type: MessageType, sentDate: NSDate, text: String) -> Message?
    {
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
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
    
    func getMessage(id: Int) -> Message?
    {
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
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
    
    func getMessagesFromChannel(channel: Int) -> [Message]
    {
        let mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", NSNumber.init(integer: channel))
        
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
    
    func getRecentMessagesFromChannel(channel: Int) -> [Message]
    {
        var mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", NSNumber.init(integer: channel))
        
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
    
    func getOldMessagesFromChannel(channel: Int) -> [Message]
    {
        var mssgs = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", NSNumber.init(integer: channel))
        
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
    func deleteMessage(id: Int) -> Int?
    {
        if let message = self.getMessage(id)
        {
            let messages = self.getMessagesFromChannel(Int(message.target))
            
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