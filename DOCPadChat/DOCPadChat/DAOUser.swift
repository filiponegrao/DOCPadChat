//
//  DAOUser.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 10/04/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData
import UIKit


private let data : DAOUser = DAOUser()

class DAOUser : NSObject
{
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    private var currentUser : User?
    
    override init() {
        
        super.init()
        
        self.currentUser = self.getFirstUser()
    }
    
    class var sharedInstance : DAOUser {
        
        return data
    }
    
    
    func createUser(id: Int, username: String, email: String, password: String, gender: String?, country: String?, city: String?)
    {
        //Deleta todos os usuarios possiveis
        do { let results = try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]
            
            for r in results
            {
                self.managedObjectContext.deleteObject(r)
                self.save()
            }
            
        } catch {
            
        }

        let user = User.createInManagedObjectContext(self.managedObjectContext, id: id, username: username, email: email, password: password, gender: gender, country: country, city: city)
        
        self.currentUser = user
        self.save()
    }
    
    
    func getCurrentUser() -> User?
    {
        if self.currentUser == nil
        {
            self.currentUser = self.getFirstUser()
        }
        
        return self.currentUser
    }
    
    func getFirstUser() -> User?
    {
        do { let results = try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]
            
            if(results.count > 0)
            {
                return results.first!
            }
            else { return nil }
        
        } catch {
            
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
    
    func deleteCurrentUser()
    {
        if(self.currentUser != nil)
        {
            self.managedObjectContext.deleteObject(self.currentUser!)
            self.save()
        }
    }
}

