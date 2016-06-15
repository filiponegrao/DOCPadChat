//
//  Message.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 04/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData


public enum MessageType : String
{
    case Text = "text"
    
    case Audio = "audio"
    
    case Video = "video"
    
    case Image = "image"
}

extension Message {
    
    @NSManaged var id: NSNumber!
    @NSManaged var sender: NSNumber!
    @NSManaged var sentDate: NSDate!
    @NSManaged var status: String!
    @NSManaged var target: NSNumber!
    @NSManaged var text: String?
    @NSManaged var type: String!
    @NSManaged var file: File?
    
}

class Message: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, sender: Int, target: Int, text: String, type: MessageType, sentDate: NSDate) -> Message
    {
        
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! Message

        message.sender = sender
        message.target = target
        message.type = type.rawValue
        message.sentDate = sentDate
        message.text = text
        message.file = nil
        
        return message
    }
    
    /**
     * Retorna false se ja existir um arquivo linkado a essa mensagem.
     * Para remover o link de arquivo, utilize o método : removeFile().
     */
    func addFile(file: File) -> Bool
    {
        if(self.file == nil)
        {
            self.file = file
            do
            {
                try self.managedObjectContext?.save()
                return true
            
            } catch { return false }
        }
        else
        {
            return false
        }
    }
    
    func removeFile()
    {
        self.file = nil
    }
    
    func getFile() -> File?
    {
        return self.file
    }
}



