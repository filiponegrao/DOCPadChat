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
    
    private var password : String!
    
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
    
    /**
     *   Parametros:
     *
     * - O id passado deve ser do formato: 'username@servername'. Ex: teste@docpad.com;
     * - O username uma string. Representa o nome de usuario no qual os contatos
     *   visualizam;
     * - Password;
     * - Imagem de perfil, opcional;
     */
    func serverConfigure(jabberId: String, username: String, password: String, profileImage: UIImage?)
    {
        self.id = jabberId
        self.username = username
        self.profileImage = profileImage
        self.password = password
    }
    
    func serverConnect()
    {
        if((self.connectionStatus() != ConnectioStatus.Desconectado))
        {
            return
        }
        
        if self.id == nil || self.password == nil { return }
        
        NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.appConnecting())
        print("Logando como: ", self.id)
        XMPPManager.sharedInstance.loginToXMPPServer(self.id, password: self.password)
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
            else if error.code == 7
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


    func didReceiveMessage(message: Message)
    {
        NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message))
    }
    
    func didSentMessage(id: String)
    {
        if DAOMessage.sharedInstance.changeMessageStatus(id, status: MessageStatus.Sent)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageSent(id))
        }
    }
    
    func addedBuddyToList(buddyList: [UserModel])
    {
        
    }
    
    /*********************************/
    /*********************************/

    
    
    func sendTextMessage(text: String, toContact contact: String) -> Bool
    {
        
        if XMPPManager.sharedInstance.connectionStatus() != ConnectioStatus.Conectado { return false }
        
        let id = "\(self.id)_\(contact)_\(NSDate())"
        
        //Texto
        let body = DDXMLElement(name: "body", stringValue: text)
        
        //Id
        let messageId = DDXMLElement(name: "id", stringValue: id)
        
        //Mensagem
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: contact)
        
        //Adiciona cada parte
        messageElement.addChild(body)
        messageElement.addChild(messageId)
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
        if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: contact, type: MessageType.Text, sentDate: NSDate(), text: text)
        {
            NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message))
            return true
        }
        
        return false
    }
    
    func sendImageMessage(text: String?, toContact contact: String, image: UIImage) -> Bool
    {
        if XMPPManager.sharedInstance.connectionStatus() != ConnectioStatus.Conectado { return false }

        let id = "\(self.id)_\(contact)_\(NSDate())"
        
        var newText = ""

        if text != nil
        {
            newText = text!
        }
        
        //Texto
        let body = DDXMLElement(name: "body", stringValue: newText)
        
        //Id
        let messageId = DDXMLElement(name: "id", stringValue: id)
        
        //Trasnforma o conteudo em string
        let data = image.highestQualityJPEGNSData
        let string = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        //Conteudo
        let messageContent = DDXMLElement(name: "content")
        messageContent.addAttributeWithName("type", stringValue: MessageType.Image.rawValue)
        messageContent.addAttributeWithName("contentData", stringValue: string as String)

        //Mensagem
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: contact)
        
        //Adiciona cada parte
        messageElement.addChild(body)
        messageElement.addChild(messageId)
        messageElement.addChild(messageContent)

        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)

        if let file = DAOFile.sharedInstance.newFile(withId: id, type: FileType.Image, content: data)
        {
            if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: contact, type: MessageType.Image, sentDate: NSDate(), text: newText)
            {
                message.addFile(file, moc: DAOMessage.sharedInstance.managedObjectContext)
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message))
                return true
            }
            
            return false
        }
        
        return false
    }
    
    func sendPrintScreenNotification(image: String, sender: String) -> Bool
    {
        if XMPPManager.sharedInstance.connectionStatus() != ConnectioStatus.Conectado { return false }

        let elementPrintScreen = DDXMLElement(name: "printScreen", stringValue: image)
        elementPrintScreen.addAttributeWithName("printDate", stringValue: "\(NSDate())")
        
        //Texto
        let body = DDXMLElement(name: "body", stringValue: "")
        
        //Id
        let messageId = DDXMLElement(name: "id", stringValue: image)
        
        //Mensagem
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: sender)
        
        //Adiciona cada parte
        messageElement.addChild(body)
        messageElement.addChild(messageId)
        messageElement.addChild(elementPrintScreen)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
        return true
    }
    
    func reSendImageMessage(message: Message) -> Bool
    {
        if XMPPManager.sharedInstance.connectionStatus() != ConnectioStatus.Conectado { return false }

        let id = "\(self.id)_\(message.target)_\(NSDate())"

        if message.file == nil { return false }
        
        //Texto
        let body = DDXMLElement(name: "body", stringValue: "")
        
        //Id
        let messageId = DDXMLElement(name: "id", stringValue: id)
        
        //Trasnforma o conteudo em string
        let data = message.file!.content
        let string = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        //Conteudo
        let messageContent = DDXMLElement(name: "content")
        messageContent.addAttributeWithName("type", stringValue: MessageType.Image.rawValue)
        messageContent.addAttributeWithName("contentData", stringValue: string as String)
        
        //Mensagem
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: message.target)
        
        //Adiciona cada parte
        messageElement.addChild(body)
        messageElement.addChild(messageId)
        messageElement.addChild(messageContent)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
      
        if let file = DAOFile.sharedInstance.newFile(withId: id, type: FileType.Image, content: message.file!.content)
        {
            if let newMessage = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: message.target, type: MessageType.Image, sentDate: NSDate(), text: "")
            {
                DAOMessage.sharedInstance.addFileToMessage(newMessage, file: file)
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(newMessage))
                return true
            }
            
            return false
        }
        
        return false
    }
    
    func sendAudioMessage(text: String?, toContact contact: String, audio: NSData) -> Bool
    {
        if XMPPManager.sharedInstance.connectionStatus() != ConnectioStatus.Conectado { return false }

        let id = "\(self.id)_\(contact)_\(NSDate())"
        
        var newText = ""
        
        if text != nil
        {
            newText = text!
        }
        
        //Texto
        let body = DDXMLElement(name: "body", stringValue: newText)
        
        //Id
        let messageId = DDXMLElement(name: "id", stringValue: id)
        
        //Trasnforma o conteudo em string
        let string = audio.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        //Conteudo
        let messageContent = DDXMLElement(name: "content")
        messageContent.addAttributeWithName("type", stringValue: MessageType.Audio.rawValue)
        messageContent.addAttributeWithName("contentData", stringValue: string as String)
        
        //Mensagem
        let messageElement = DDXMLElement(name: "message")
        messageElement.addAttributeWithName("type", stringValue: "chat")
        messageElement.addAttributeWithName("to", stringValue: contact)
        
        //Adiciona cada parte
        messageElement.addChild(body)
        messageElement.addChild(messageId)
        messageElement.addChild(messageContent)
        
        XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
        
        if let file = DAOFile.sharedInstance.newFile(withId: id, type: FileType.Audio, content: audio)
        {
            if let message = DAOMessage.sharedInstance.newMessage(id, sender: self.id, target: contact, type: MessageType.Audio, sentDate: NSDate(), text: newText)
            {
                message.addFile(file, moc: DAOMessage.sharedInstance.managedObjectContext)
                NSNotificationCenter.defaultCenter().postNotification(ChatNotifications.messageNew(message))
                return true
            }
            
            return false
        }
        
        return false
    }
    
    func deleteAllSentMedia(target: String)
    {
        DAOMessage.sharedInstance.deleteAllMessageContentsSentTo(target)
    }
    
    /**
     * Efetua a exclusao e retorna o id correspondente às mensagens
     * que possuem um Arquvio e foram enviadas para o 'target'.
     */
    func deleteSentMedia(id: String, target: String) -> Int?
    {
        return DAOMessage.sharedInstance.deleteMessageContentSent(id, target: target)
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
    
    
}

