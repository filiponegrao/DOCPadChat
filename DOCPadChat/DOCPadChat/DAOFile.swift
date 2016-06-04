//
//  DAOFile.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data : DAOFile = DAOFile()

class DAOFile : NSObject
{
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    class var sharedInstance : DAOFile
    {
        return data;
    }
    
    /**
     * New File: Criacao com nome
     *
     * Método responsavel por criar um elemento File no armazenamento
     * local. Criando com sucesso retorna o arquivo criado.
     */
    func newFile(name: String, type: FileType, content: NSData) -> File?
    {
        let query = NSFetchRequest(entityName: "File")
        
        let predicate = NSPredicate(format: "name == %@ ", name)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            if results.count != 0
            {
                return nil
            }
            
            let file = File.createInManagedObjectContext(self.managedObjectContext, name: name, content: content, type: type)
            
            self.save()
            
            return file
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * New File: Criacao com id
     *
     * Método responsavel por criar um elemento File no armazenamento
     * local. Criando com sucesso retorna o arquivo criado.
     */
    func newFile(id: Int, type: FileType, content: NSData) -> File?
    {
        let query = NSFetchRequest(entityName: "File")
        
        let predicate = NSPredicate(format: "id == %@ ", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            if results.count != 0
            {
                return nil
            }
            
            let file = File.createInManagedObjectContext(self.managedObjectContext, id: id, content: content, type: type)
            
            self.save()
            
            return file
        }
        catch
        {
            return nil
        }
    }

    /**
     * Get File: Procura um arquivo por id.
     *
     * Encontrado com sucesso, o arquivo é retornado.
     */
    func getFile(id: Int) -> File?
    {
        let query = NSFetchRequest(entityName: "File")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber.init(integer: id))
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            return results.first
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * Get File: Procura um arquivo por nome.
     *
     * Encontrado com sucesso, o arquivo é retornado.
     */
    func getFile(name name: String) -> File?
    {
        let query = NSFetchRequest(entityName: "File")
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        query.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            return results.first
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * Delete File: Exclusao por id.
     *
     * Método responsavel por excluir um arquivo armazenado localmente.
     * Se a exclusao for sucedida, é retornado o index o qual o arquivo
     * ocupava na lista dos arquivos locais.
     */
    func deleteFile(id: Int) -> Int?
    {
        let query = NSFetchRequest(entityName: "File")
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            for i in 0..<results.count
            {
                if let id = results[i].id
                {
                    if Int(id) == id
                    {
                        self.managedObjectContext.deleteObject(results[i])
                        
                        self.save()
                        
                        return i
                    }
                }
            }
            
            return nil
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * Delete File: Exclusao por nome.
     *
     * Método responsavel por excluir um arquivo armazenado localmente.
     * Se a exclusao for sucedida, é retornado o index o qual o arquivo
     * ocupava na lista dos arquivos locais.
     */
    func deleteFile(name: String) -> Int?
    {
        let query = NSFetchRequest(entityName: "File")
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [File]
            
            for i in 0..<results.count
            {
                if let n = results[i].name
                {
                    if n == name
                    {
                        self.managedObjectContext.deleteObject(results[i])
                        
                        self.save()
                        
                        return i
                    }
                }
            }
            
            return nil
        }
        catch
        {
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
}