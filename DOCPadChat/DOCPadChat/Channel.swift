//
//  Channel.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public enum ChannelType : String
{
    case Single = "single"
    
    case Group = "group"
}

extension Channel {
    
    @NSManaged var author: NSNumber!
    @NSManaged var createdAt: NSDate!
    @NSManaged var id: NSNumber!
    @NSManaged var image: NSData!
    @NSManaged var name: String!
    @NSManaged var type: String!
    @NSManaged var updatedAt: NSDate!
    @NSManaged var sessions: NSSet?
    
}

class Channel: NSManagedObject {
    
    /**
     * Conversa entre duas pessoas
     *
     * Funcao responsavel por criar um canal entre duas pessoas.
     * Representa uma conversa
     */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, session: Session) -> Channel
    {
        let channel = NSEntityDescription.insertNewObjectForEntityForName("Channel", inManagedObjectContext: moc) as! Channel
        
        channel.author = 0
        channel.createdAt = NSDate()
        channel.id = id
        channel.image = session.profileImage
        if(session.profileImage == nil) { print("vish, ta nulo") }
        
        channel.name = session.nickname
        channel.type = ChannelType.Single.rawValue
        channel.updatedAt = NSDate()
        
        let sessions = NSSet.init(array: [session])
        channel.sessions = sessions
        
        return channel
    }
    
    /**
     * Conversa em grupo
     *
     * Funcao responsavel por criar um canal entre varias pessoas.
     */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: Int, name: String, author: Int, sessions: [Session]) -> Channel
    {
        let channel = NSEntityDescription.insertNewObjectForEntityForName("Channel", inManagedObjectContext: moc) as! Channel
        
        channel.author = author
        channel.id = id
        channel.image = UIImage(named: "channelTemplate")!.highestQualityJPEGNSData
        channel.name = name
        channel.type = ChannelType.Group.rawValue
        channel.createdAt = NSDate()
        channel.updatedAt = NSDate()
        
        let sessionsarray = NSSet.init(array: sessions)
        channel.sessions = sessionsarray
        
        return channel
    }
    
    /**
     * Retorna a sessão de um canal do tipo conversa.
     */
    func getSessionFromSingleChannel() -> Session?
    {
        if self.type == ChannelType.Single.rawValue
        {
            if let sessions = self.sessions?.allObjects as? [Session]
            {
                return sessions.first
            }
        }
        
        return nil
    }
    
    /**
     * Retorna todas as sessoes de um canal do tipo grupo.
     */
    func getSessionsFromGroupChannel() -> [Session]?
    {
        if self.type == ChannelType.Group.rawValue
        {
            if let sessions = self.sessions?.allObjects as? [Session]
            {
                return sessions
            }
            
            return nil
        }
        
        return nil
    }
    
    /**
     * Adiciona uma sessao a um canal do tipo conversa.
     * Se o canal estiver vazio aceita a adição, caso contrario,
     * rejeita.
     */
    func addSessionToSingleChannel(session: Session, moc: NSManagedObjectContext) -> Bool
    {
        if self.type != ChannelType.Single.rawValue { return false }
        
        if var currentSessions = self.sessions?.allObjects as? [Session]
        {
            if currentSessions.count != 0 { return false }
            
            currentSessions.append(session)
            
            self.sessions = NSSet.init(array: [currentSessions])
            do
            {
                try moc.save()
                return true
                
            }
            catch
            {
                "Nao foi possivel adicionar \(session.nickname) ao Canal"
                return false
            }
        }
        
        return false
    }
    
    /**
     * Adiciona sessoes a um canal do tipo Grupo.
     */
    func addSessionsToGroupChannel(sessions: [Session], moc: NSManagedObjectContext) -> Bool
    {
        if self.type == ChannelType.Single.rawValue { return false }
        
        if var currentSessions = self.sessions?.allObjects as? [Session]
        {
            for s in sessions
            {
                if !self.isAlreadyMember(s)
                {
                    currentSessions.append(s)
                }
            }
            
            self.sessions = NSSet.init(array: currentSessions)
            do
            {
                try moc.save()
                return true
            }
            catch
            {
                "Nao foi possivel adicionar as sessoes ao grupo \(self.name)"
                return false
            }
        }
        
        return false
    }
    
    func isAlreadyMember(session: Session) -> Bool
    {
        if let currentSessions = self.sessions?.allObjects as? [Session]
        {
            for s in currentSessions
            {
                if session.id == s.id
                {
                    return true
                }
            }
            
            return false
        }
        
        return false
    }

}
