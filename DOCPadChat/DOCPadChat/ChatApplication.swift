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


@objc protocol ChatApplicationDelegate
{
    func chatApplication(application: ChatApplication, newMessage: Message)
}

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
    
    /** Informacoes do usuario corrente */
    
    private var id : String!
    
    private var username : String!
    
    private var profileImage : UIImage?
    
    /** Fim das informacoes do usuario corrente */
    
    weak var delegate : ChatApplicationDelegate?
    
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
    
    func connectionStatus() -> ConnectioStatus
    {
        return XMPPManager.sharedInstance.connectionStatus()
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
        if((self.connectionStatus() != ConnectioStatus.Desconectado))
        {
            return
        }
        
        if(self.username != nil)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appConnecting())
            
            let address = "\(self.id)@\(self.ip)"
            print("Logando como: ", address)
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
        
        NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appConnected())
        
        let presence = XMPPPresence(type: "Available")
        XMPPManager.sharedInstance.xmppStream?.sendElement(presence)
    }
    
    func didDisconnected(error: NSError?)
    {
        if let error = error
        {
            if error.code == 51
            {
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appNoInternet())
            }
            else if error.code == 57
            {
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appDisconnected(error))
                self.serverConnect()
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appDisconnected(error))
            }
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appDisconnected(error))
        }
    }
    
    func didConnectionTimedOut(error: NSError)
    {
        NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appTimeOut(error))
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
        let sender = message.messageSender
        let text = message.messageBody
        
        let id = "\(sender)\(NSDate())"
        
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: sender, target: self.id, type: MessageType.Text, sentDate: NSDate(), text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: sender))
            self.delegate?.chatApplication(self, newMessage: message)
        }
    }
    
    func didSentMessage(id: String)
    {
        if DAOMessage.sharedInstance.changeMessageStatus(id, status: MessageStatus.Sent)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageSent(id))
        }
    }
    
    func addedBuddyToList(buddyList: [UserModel]) {
        
    }
    
    /*********************************/
    /*********************************/

    
    
    func sendTextMessage(text: String, toId id: String)
    {
        let id = "\(self.id)_\(id)_\(NSDate())"
        
        let body = DDXMLElement(name: "body", stringValue: text)
        
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("id", stringValue: id)
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: id)
        messageElement.addChild(body)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: id, type: MessageType.Text, sentDate: NSDate(), text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: self.id))
        }
    }
    
    func sendImageMessage(text: String?, toId id: String, image: UIImage)
    {
        
        let id = "\(self.id)_\(id)_\(NSDate())"
        
        var newText = ""

        if text != nil
        {
            newText = text!
        }
        
        let body = DDXMLElement(name: "body", stringValue: newText)
        
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("id", stringValue: id)
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: id)
        messageElement.addChild(body)
        
        let data = image.highestQualityJPEGNSData
        let string = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        let attachement = DDXMLElement(name: "attachement")
        attachement.setStringValue(string as String)
        
        messageElement.addChild(attachement)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)

        if let file = DAOFile.sharedInstance.newFile(withId: id, type: FileType.Image, content: data)
        {
            if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: id, type: MessageType.Image, sentDate: NSDate(), text: newText)
            {
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: self.id))
            }
        }
    }
    
    func sendAudioMessage(text: String?, toId id: String, audio: NSData)
    {
        
        let id = "\(self.id)_\(id)_\(NSDate())"
        
        var newText = ""
        
        if text != nil
        {
            newText = text!
        }
        
        let body = DDXMLElement(name: "body", stringValue: newText)
        
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("id", stringValue: id)
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: id)
        messageElement.addChild(body)
        
        let string = audio.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        let attachement = DDXMLElement(name: "attachement")
        attachement.setStringValue(string as String)
        
        messageElement.addChild(attachement)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
        if let file = DAOFile.sharedInstance.newFile(withId: id, type: FileType.Audio, content: audio)
        {
            if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: id, type: MessageType.Image, sentDate: NSDate(), text: newText)
            {
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message, sender: self.id))
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
    
    private func deleteMessage(message: Message)
    {
        if let index = DAOMessage.sharedInstance.deleteMessage(message.id)
        {

        }
    }
}

