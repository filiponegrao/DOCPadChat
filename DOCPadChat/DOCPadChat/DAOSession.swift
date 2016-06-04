//
//  DAOSession.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData


private let data = DAOSession()

class DAOSession : NSObject
{
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    class var sharedInstance : DAOSession
    {
        return data
    }
    
    /**
     * New Session
     *
     * Método responsavel por criar uma Sessao localmente.
     * Uma Sessao representa um contato para conversação.
     *
     * Se criada com sucesso, a sessao é retornada.
     */
    func newSession(id: Int, nickname: String, profileImage: NSData?) -> Session?
    {
        let query = NSFetchRequest(entityName: "Session")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Session]
            
            if results.count != 0 { return nil }
            
            let session = Session.createInManagedObjectContext(self.managedObjectContext, id: id, nickname: nickname, profileImage: profileImage)
            
            self.save()
            
            return session
        }
        catch { return nil }
    }
    
    /**
     * Delete Session
     * 
     * Método responsavel por excluir uma Sessão localmente.
     *
     * Se excluida com sucesso, o index a qual a sessao ocupava
     * na lista de sessoes é retornado.
     */
    func deleteSession(id: Int) -> Int?
    {
        let query = NSFetchRequest(entityName: "Session")
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Session]
            
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
        catch { return nil }
    }
    
    /** Retorna uma sessao por um id */
    func getSession(id: Int) -> Session?
    {
        let query = NSFetchRequest(entityName: "Session")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Session]
            
            return results.first
        }
        catch { return nil }
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


