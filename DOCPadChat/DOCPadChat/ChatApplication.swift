//
//  ChatApplication.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit


/**
 * Some enums
 */

public enum ConnectioStatus : String
{
    case Conectando
    
    case Conectado
    
    case Desconectado
}

private let data : ChatApplication = ChatApplication()

class ChatApplication : NSObject
{
    private var connectionStatus : ConnectioStatus!
    
    /** Informacoes do usuario corrente */
    
    private var id : Int!
    
    private var username : String!
    
    private var profileImage : UIImage!
    
    /** Fim das informacoes do usuario corrente */
    
    
    class var sharedInstance : ChatApplication {
        
        return data
    }
    
    override init()
    {
        super.init()
        
        if let user = DAOUser.sharedInstance.getFirstUser()
        {
            self.id = Int(user.id)
            self.username = user.username
        }
    }
    
    func getId() -> Int?
    {
        return self.id
    }
    
    func getUsername() -> String?
    {
        return self.username
    }
    
    func isConnected() -> Bool
    {
        if(self.connectionStatus == ConnectioStatus.Conectado)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    func createMainUser(id: Int, username: String, email: String?, password: String?, gender: String?, country: String?, city: String?, profileImage: UIImage) -> Bool
    {
        if let user = DAOUser.sharedInstance.createUser(id, username: username, email: email, password: password, gender: gender, country: country, city: city, profileImage: profileImage)
        {
            self.id = id
            self.username = username
            return true
        }
        
        return false
    }
    
    func createMainUser(id: Int, username: String, profileImage: UIImage?) -> Bool
    {
        if let user = DAOUser.sharedInstance.createUser(id, username: username, email: nil, password: nil, gender: nil, country: nil, city: nil, profileImage: profileImage)
        {
            self.id = id
            self.username = username
            return true
        }
        
        return false
    }
    
    func setMainUser(id: Int) -> Bool
    {
        if let user = DAOUser.sharedInstance.getUser(id)
        {
            self.id = Int(user.id)
            self.username = user.username
            return true
        }
        
        return false
    }
    

    /*********************************/
    /****** TESGIN FUNCTIONS *********/
    /*********************************/
    
    func testing()
    {
        if let session = DAOSession.sharedInstance.newSession(01, nickname: "Robot", profileImage: UIImage(named: "robot")!.highestQualityJPEGNSData)
        {
            if let channel = DAOChannel.sharedInstance.newChannel(01, session: session)
            {
                return
            }
            print("Ja existe")
        }
    }
    
    func sendMessage(id: Int, target: Int, text: String)
    {
        self.newMessage(id, sender: self.id, target: target, type: MessageType.Text, sentDate: NSDate(), text: text)
    }
    
    /*********************************/
    /*********************************/

    
    func startChatWith(askingController: UIViewController, channel: Channel, navigationController: Bool, animated: Bool)
    {
        
        if (self.id == nil || self.username == nil) { return }
        
        let controller = ChatNavigationController(channel: channel)
        
        if navigationController
        {
            if let navigation = askingController.navigationController
            {
                navigation.pushViewController(controller, animated: animated)
            }
        }
        else
        {
            askingController.presentViewController(askingController, animated: animated, completion: { 
                
            })
        }
    }
    
    func startChatWith(askingController: UIViewController, channelId id: Int, navigationController: Bool, animated: Bool)
    {
        if (self.id == nil || self.username == nil) { return }

        if let channel = DAOChannel.sharedInstance.getChannel(id)
        {
            let controller = ChatNavigationController(channel: channel)
            
            if navigationController
            {
                if let navigation = askingController.navigationController
                {
                    navigation.pushViewController(controller, animated: animated)
                }
            }
            else
            {
                askingController.presentViewController(controller, animated: animated, completion: {
                    
                })
            }
        }
    }
    
    
    private func newSession(id: Int, nickname: String, profileImage: UIImage?)
    {
        if let session = DAOSession.sharedInstance.newSession(id, nickname: nickname)
        {
            if(profileImage != nil) { DAOSession.sharedInstance.changeSessionImage(id, image: profileImage!) }
            
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.sessionNew(session))
        }
    }
    
    private func deleteSession(id: Int)
    {
        if let index = DAOSession.sharedInstance.deleteSession(id)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.sessionRemoved(id, index: index))
        }
    }
    
    private func newConversation(id: Int, session: Session)
    {
        if let channel = DAOChannel.sharedInstance.newChannel(id, session: session)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.channelNew(channel))
        }
    }
    
    private func newGroup(id: Int, author: Int, name: String, sessions: [Session])
    {
        if let channel = DAOChannel.sharedInstance.newChannel(id, sessions: sessions, name: name, author: author)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.channelNew(channel))
        }
    }
    
    
    private func deleteChannel(id: Int)
    {
        if let index = DAOChannel.sharedInstance.deleteChannel(id)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.channelDropped(index, id: id))
        }
    }
    
    private func addSessionToChannel(channel: Int, session: Session)
    {
        if DAOChannel.sharedInstance.addSessionToChannel(channel, session: session)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.channelMember(channel, member: session))
        }
    }
    
    private func newMessage(id: Int, sender: Int, target: Int, type: MessageType, sentDate: NSDate, text: String)
    {
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: sender, target: target, type: type, sentDate: sentDate, text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, channel: target))
        }
    }
    
    private func deleteMessage(message: Message)
    {
        if let index = DAOMessage.sharedInstance.deleteMessage(Int(message.id))
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageDeleted(Int(message.id), channel: Int(message.target), index: index))
        }
    }
}



