//
//  ChatApplication.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 03/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework


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

class ChatApplication : NSObject, XMPPManagerLoginDelegate, XMPPManagerStreamDelegate, XMPPManagerRosterDelegate
{
    /** Server information */
    
    let ip : String = "52.67.65.109"

    let port : Int = 5222
    
    private var connectionStatus : ConnectioStatus!
    
    /** Informacoes do usuario corrente */
    
    private var id : String!
    
    private var username : String!
    
    private var profileImage : UIImage?
    
    /** Fim das informacoes do usuario corrente */
    
    
    class var sharedInstance : ChatApplication {
        
        return data
    }
    
    override init()
    {
        super.init()
        self.registerXMPPDelegate()
 
    }
    
    func getId() -> String?
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
    
    func registerXMPPDelegate()
    {
        XMPPManager.sharedInstance.setXMPPDelegates()
        XMPPManager.sharedInstance.xmppManagerLoginDelegate = self
        XMPPManager.sharedInstance.xmppManagerRosterDelegate = self
        XMPPManager.sharedInstance.xmppManagerStreamDelegate = self
    }
    
    func serverConfigure(id: String, username: String, profileImage: UIImage?)
    {
        self.id = id
        self.username = username
        self.profileImage = profileImage
    }
    
    func serverConfigure(profileImage: UIImage)
    {
        self.profileImage = profileImage
        
    }
    
    func serverConnect()
    {
        if(self.username != nil)
        {
            let address = "\(self.id)@\(self.ip)"
            print(address)
            XMPPManager.sharedInstance.loginToXMPPServer(address, password: "1234")
        }
    }
    
    func serverDisconnect()
    {
        XMPPManager.sharedInstance.disconnect()
    }
    
    /*********************************/
    /******** XMPP DELEGATES *********/
    /*********************************/
    
    func didConnectToServer(bool: Bool, errorMessage: String?)
    {
        print("Connectado!")
        let presence = XMPPPresence(type: "Available")
        XMPPManager.sharedInstance.xmppStream?.sendElement(presence)
    }
    
    func failedToAuthenticate(error: String)
    {
        print("Failed to authenticate")
    }
    
    func startChatWith(askingController: UIViewController, userModel: UserModel, navigationController: Bool, animated: Bool, completion : (()->())?)
    {
        let chat = ChatNavigationController(userModel: userModel)
        
        if navigationController
        {
            askingController.navigationController?.pushViewController(chat, animated: animated)
            self.serverConnect()
        }
        else
        {
            askingController.presentViewController(chat, animated: animated, completion: {
                self.serverConnect()
                completion?()
            })
        }
    }


    func didReceiveMessage(message: MessageModel)
    {
        print(message)
        
        let sender = message.messageSender
        let text = message.messageBody
        
        print("Sender", sender, "Text", text)
        
        let id = "\(sender)\(NSDate())"
        
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: sender, target: self.id, type: MessageType.Text, sentDate: NSDate(), text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: sender))
        }
    }
    
//    func didReceivePresence(presence : UserState, from : UserModel) {
//        
//    }
    
    
    func addedBuddyToList(buddyList :[UserModel]) {

    }
    
    /*********************************/
    /*********************************/

    
    
    func sendMessage(text: String, toId id: String)
    {
        let body = DDXMLElement(name: "body", stringValue: text)
        
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: id)
        messageElement.addChild(body)
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        let id = "\(self.id)\(NSDate())"
        
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: id, type: MessageType.Text, sentDate: NSDate(), text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: self.id))
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
    
    private func newMessage(id: String, sender: String, target: String, type: MessageType, sentDate: NSDate, text: String)
    {
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: sender, target: target, type: type, sentDate: sentDate, text: text)
        {
           
        }
    }
    
    private func deleteMessage(message: Message)
    {
        if let index = DAOMessage.sharedInstance.deleteMessage(message.id)
        {

        }
    }
}

