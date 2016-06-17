//
//  ChatNotifications.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 28/04/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation

class ChatNotifications : NSObject
{
    
    //Server controller notifcations
    
    class func commandMissing(event: String, parameter: String) -> NSNotification
    {
        return NSNotification(name: Event.command_missing.rawValue, object: nil, userInfo: ["event": event, parameter: parameter])
    }
    
    class func commandIncorrect() -> NSNotification
    {
        return NSNotification(name: Event.command_incorrect.rawValue, object: nil, userInfo: nil)
    }
    
    class func notConnected() -> NSNotification
    {
        return NSNotification(name: "net_disconected", object: nil)
    }
    
    class func timeOut() -> NSNotification
    {
        return NSNotification(name: "net_timeout", object: nil)
    }
    
    //Accounts 
    
    class func accountRequired() -> NSNotification
    {
        return NSNotification(name: Event.account_required.rawValue, object: nil)
    }
    
    class func accountRejected(email: String) -> NSNotification
    {
        return NSNotification(name: Event.account_rejected.rawValue, object: nil, userInfo: ["email":email])
    }
    
    class func accountIncorrect(incorrectField: String?) -> NSNotification
    {
        if incorrectField == nil
        {
            return NSNotification(name: Event.account_incorrect.rawValue, object: nil, userInfo: nil)
        }
        
        return NSNotification(name: Event.account_incorrect.rawValue, object: nil, userInfo: ["field":incorrectField!])
    }
    
    class func accountConnected(session: Int) -> NSNotification
    {
        return NSNotification(name: Event.account_connected.rawValue, object: nil, userInfo: ["id": session])
    }
    
    //Sessions
    
    class func sessionResult(sessions: [Session]) -> NSNotification
    {
        return NSNotification(name: Event.session_result.rawValue, object: nil, userInfo: ["result": sessions])
    }
    
//    class func sessionInvitationNotification(invitation: SessionInvitation) -> NSNotification
//    {
//        return NSNotification(name: Event.session_invitation.rawValue, object: nil, userInfo: ["invitation": invitation])
//    }
    
    class func sessionInvitationDenied(index: Int, currentUserIsSender: Bool) -> NSNotification
    {
        return NSNotification(name: Event.session_denied.rawValue, object: nil, userInfo: ["index": index, "sender": currentUserIsSender])
    }
    
    class func sessionNew(session: Session) -> NSNotification
    {
        return NSNotification(name: Event.session_new.rawValue, object: nil, userInfo: ["session": session])
    }
    
    class func sessionRemoved(id: Int, index: Int) -> NSNotification
    {
        return NSNotification(name: Event.session_removed.rawValue, object: nil, userInfo: ["session": id, "index": index])
    }
    
    class func sessionChanged(id: Int, nickname: String) -> NSNotification
    {
        return NSNotification(name: Event.session_changed.rawValue, object: nil, userInfo: ["session": id, "nickname": nickname])
    }
    
    class func sessionBlocked(session: Int) -> NSNotification
    {
        return NSNotification(name: Event.session_blocked.rawValue, object: nil, userInfo: ["session": session])
    }
    
    class func sessionUnblocked(session: Int) -> NSNotification
    {
        return NSNotification(name: Event.session_unblocked.rawValue, object: nil, userInfo: ["session": session])
    }
    
    //Channels
    
    class func channelNew(channel: Channel) -> NSNotification
    {
        return NSNotification(name: Event.channel_new.rawValue, object: nil, userInfo: ["channel": channel])
    }
    
    class func channelMember(channel: Int, member: Session) -> NSNotification
    {
        return NSNotification(name: Event.channel_member.rawValue, object: nil, userInfo: ["channel":channel, "member":member])
    }
    
    class func channelQuitted(channel: Int, member: Int) -> NSNotification
    {
        return NSNotification(name: Event.channel_quitted.rawValue, object: nil, userInfo: ["channel": channel, "member": member])
    }
    
    class func channelRenamed(channel: Int, name: String) -> NSNotification
    {
        return NSNotification(name: Event.channel_renamed.rawValue, object: nil, userInfo: ["channel": channel, "name": name])
    }
    
    class func channelDropped(index: Int, id: Int) -> NSNotification
    {
        return NSNotification(name: Event.channel_dropped.rawValue, object: nil, userInfo: ["index":index, "id": id])
    }
    
    //Users
    
    class func sessionTyping(session: Int, channel: Int) -> NSNotification
    {
        return NSNotification(name: Event.user_typing.rawValue, object: nil, userInfo: ["session": session, "channel": channel])
    }
    
    class func sessionOnline(session: Int) -> NSNotification
    {
        return NSNotification(name: Event.user_online.rawValue, object: nil, userInfo: ["session": session])
    }
    
    class func sessionOffline(session: Int) -> NSNotification
    {
        return NSNotification(name: Event.user_offline.rawValue, object: nil, userInfo: ["session": session])
    }

    
    //Messages
    
    class func messageNew(message: Message, sender: String) -> NSNotification
    {
        return NSNotification(name: Event.message_new.rawValue, object: nil, userInfo: ["message": message, "sender": sender])
    }
    
    class func messageSeen(message: String, channel: String, session: Int) -> NSNotification
    {
        return NSNotification(name: Event.message_seen.rawValue, object: nil, userInfo: ["message": message, "channel": channel, "session": session])
    }
    
    class func messageDeleted(message: String, channel: String, index: Int) -> NSNotification
    {
        return NSNotification(name: Event.message_deleted.rawValue, object: nil, userInfo: ["message": message, "channel": channel, "index": index])
    }
    
}















