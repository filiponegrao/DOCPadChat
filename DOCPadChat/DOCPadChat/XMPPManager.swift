//
//  XMPPManager.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/18/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit
import XMPPFramework


enum ConnectionStatus : String
{
    case Disconnected = "disconnected"
    
    case Connecting = "connecting"
    
    case Connected = "connected"
}

protocol XMPPManagerLoginDelegate
{
    func didConnectToServer(bool : Bool, errorMessage : String?)
    
    func failedToAuthenticate(error : String)
}

protocol XMPPManagerStreamDelegate
{
    func didReceiveMessage(message : MessageModel)
    
    func didConnectionTimedOut(error: NSError)
    
    func didDisconnected(error: NSError?)
    
    func didSentMessage(id: String)

//    func didReceivePresence(presence : UserState, from : UserModel)
}

protocol XMPPManagerRosterDelegate
{
//    func didReceivePresence(presence : UserState, from : String)
    func addedBuddyToList(buddyList :[UserModel])
    
}

class XMPPManager: NSObject {
    
    static let sharedInstance = XMPPManager()
    
    var xmppStream : XMPPStream?
    var xmppRoster : XMPPRoster?
    var xmppRosterManager : XMPPRosterMemoryStorage?
    
    var xmppManagerLoginDelegate : XMPPManagerLoginDelegate?
    var xmppManagerStreamDelegate : XMPPManagerStreamDelegate?
    var xmppManagerRosterDelegate : XMPPManagerRosterDelegate?
    
    var userListArray = [UserModel]()
    
    var userWithHost : String = ""
    var password : String = ""
    
    func setXMPPDelegates()
    {
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppRosterManager = XMPPRosterMemoryStorage()
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterManager, dispatchQueue: dispatch_get_main_queue())
        xmppRoster?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppRoster?.activate(xmppStream)
    }
    
    func loginToXMPPServer(jid : String, password : String) {
        self.userWithHost = jid
        self.password = password
        
        xmppStream?.myJID = XMPPJID.jidWithString(self.userWithHost)
        
        do {
            try xmppStream?.connectWithTimeout(10.0)
        } catch {
            print("Whoops! And Error occured! When attempting to connect")
        }
    }
    
    func disconnect()
    {
        self.xmppStream?.disconnect()
    }
    
    func connectionStatus() -> ConnectioStatus
    {
        if let xmpp = self.xmppStream
        {
            if xmpp.isConnected()
            {
                return ConnectioStatus.Conectado
            }
            else if xmpp.isConnecting()
            {
                return ConnectioStatus.Conectando
            }
            else if xmpp.isDisconnected()
            {
                return ConnectioStatus.Desconectado
            }
        }
        
        return ConnectioStatus.Desconectado
    }
}

extension XMPPManager : XMPPStreamDelegate
{
    
    func xmppStreamWillConnect(sender: XMPPStream!)
    {
        print("Will Connect soon")
    }
    
    func xmppStreamDidStartNegotiation(sender: XMPPStream!)
    {
        print("Negotiating with server")
    }
    
    func xmppStreamDidConnect(sender: XMPPStream!)
    {
        print("Stream did connect!")
        
        do
        {
            try xmppStream?.authenticateWithPassword(self.password)
        }
        catch
        {
            print("An error occured!")
        }
    }
    
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!)
    {
        xmppManagerStreamDelegate?.didDisconnected(error)
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("The XMPP Authenticated")
        print(sender)
        xmppManagerLoginDelegate?.didConnectToServer(true, errorMessage: nil)
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        xmppManagerLoginDelegate?.failedToAuthenticate("Could not authenticate")
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
                
        if message.body() == nil || message.from() == nil
        {
            return
        }
        
        let body = message.body()
        let sender = message.from().bare()
        let timeStamp = "\(NSDate().timeIntervalSince1970)"
        
        let messageModel = MessageModel(body: body, sender: sender, timestamp: timeStamp)
        
        self.xmppManagerStreamDelegate?.didReceiveMessage(messageModel)
    }
    
//    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
//        let userState : UserState
//        
//        if presence.type() == "available" {
//            userState = .Available
//        } else {
//            userState = .Unavailable
//        }
//        
//        xmppManagerRosterDelegate?.didReceivePresence(userState, from: presence.from().bare())
//    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!)
    {
//        print(message)
        
        if let id = message.attributeStringValueForName("id")
        {
            self.xmppManagerStreamDelegate?.didSentMessage(id)
            print("mensagem \(id) enviada!")
        }
    }
    
    func xmppStreamConnectDidTimeout(sender: XMPPStream!)
    {
        self.xmppManagerStreamDelegate?.didConnectionTimedOut(NSError(domain: "Timedout", code: 001, userInfo: nil))
    }
}

extension XMPPManager : XMPPRosterDelegate
{
//    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!)
//    {
//        print("Sender: ", sender)
//        print("Um usuario:", item)
//        
//        let jid = item.attributeForName("jid").stringValue()
//        let name = item.attributeForName("name").stringValue()
//        
//        let userModel = UserModel(userJID: name, userNickName: jid)
//        userModel.userState = UserState.Unavailable
//        userListArray.append(userModel)
//        
//        xmppManagerRosterDelegate?.addedBuddyToList(userListArray)
//    }
    
    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        print("Recieved Subscription!")
    }
}
