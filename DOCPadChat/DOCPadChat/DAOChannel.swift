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
    
    
//    func newSingleChannel() -> Channel?
//    {
//        
//    }
//    
//    func newGroupChannel() -> Channel?
//    {
//        
//    }
//    
//    func addSessionToGroup(group: Int, session: Session) -> Bool
//    {
//        
//    }
//    
//    func getChannelFromSession(session: Int) -> Channel?
//    {
//        
//    }
//    
//    func getChannel(id: Int) -> Channel?
//    {
//        
//    }
//    
//    func setChannelName(id: Int, name: String) -> Bool
//    {
//        
//    }
    
    
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
}