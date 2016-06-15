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
    
    
    override init()
    {
        super.init()
    }
    
    class var sharedInstance : DAOUser {
        
        return data
    }
    
    
    func createUser(id: Int, username: String, email: String?, password: String?, gender: String?, country: String?, city: String?, profileImage: UIImage?) -> User?
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

        let user = User.createInManagedObjectContext(self.managedObjectContext, id: id, username: username, email: email, password: password, gender: gender, country: country, city: city, profileImage: profileImage?.highestQualityJPEGNSData)
        
        self.save()
        
        return user
    }
    
    func getFirstUser() -> User?
    {
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]
            
            return results.first
        
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
    
    func deleteUser(id: Int) -> Bool
    {
        if let user = self.getUser(id)
        {
            self.managedObjectContext.deleteObject(user)
            self.save()
            
            return true
        }
        
        return false
    }
    
    func getUser(id: Int) -> User?
    {
        let query = NSFetchRequest(entityName: "User")
        
        query.predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [User]
            
            return results.first
        }
        catch
        {
            return nil
        }
    }
    
}

