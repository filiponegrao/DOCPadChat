//
//  File.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData


public enum FileType : String
{
    case Image
    
    case Video
    
    case Audio
    
    case Gif
}

extension File {
    
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var content: NSData!
    @NSManaged var createdAt: NSDate!
    @NSManaged var updatedAt: NSDate!
    @NSManaged var type: String?
    
}

class File: NSManagedObject {


    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, content: NSData, type: FileType) -> File
    {
        
        let file = NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: moc) as! File
        file.id = id
        file.name = nil
        file.createdAt = NSDate()
        file.updatedAt = file.createdAt
        file.type = type.rawValue
        
        return file
    }
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, content: NSData, type: FileType) -> File
    {
        
        let file = NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: moc) as! File
        file.id = nil
        file.name = name
        file.createdAt = NSDate()
        file.updatedAt = file.createdAt
        file.type = type.rawValue
        
        return file
    }
}
