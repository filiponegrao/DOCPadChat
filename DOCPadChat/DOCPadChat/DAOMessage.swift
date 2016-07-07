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
    
    func changeMessageStatus(id: String, status: MessageStatus) -> Bool
    {
        if let message = self.getMessage(id)
        {
            message.status = status.rawValue
            self.save()
            
            return true
        }
        
        return false
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
    
//    func getMessagesFrom(id: String) -> [Message]
//    {
//        let messages = [Message]()
//        
//        do { return try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Message")) as! [Message] }
//            
//        catch {}
//        
//        return messages
//    }
    
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
    
    func getMessagesWithContent(target: String) -> [Message]
    {
        var messages = [Message]()
        
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", target)
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            for message in results
            {
                if message.file != nil
                {
                    messages.append(message)
                }
            }
            
            return messages
        }
        catch { return messages }
    }
    
    /**
     * Efetua a exclusao e retorna o id correspondente às mensagens
     * que possuem um Arquvio e foram enviadas para o 'target'.
     */
    func deleteMessageContentSent(id: String, target: String) -> Int?
    {
        let messages = self.getMessagesWithContent(target)
        
        for i in 0..<messages.count
        {
            if messages[i].file!.id == id
            {
                self.managedObjectContext.deleteObject(messages[i])
                self.save()
                return i
            }
        }
        
        return nil
    }
    
    func deleteAllMessageContentsSentTo(target: String)
    {
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "target == %@", target)
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            for message in results
            {
                if message.file != nil
                {
                    self.managedObjectContext.deleteObject(message.file!)
                    self.save()
                }
            }
        }
        catch { return }
    }
    
    
    
    func getMessagesWithContact(me: String, contact: String) -> [Message]
    {
        let query = NSFetchRequest(entityName: "Message")
        
        let predicate = NSPredicate(format: "(sender == %@ and target == %@) or (sender == %@ and target == %@)", me, contact, contact, me)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            
            return results
        }
        catch { return [Message]() }
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