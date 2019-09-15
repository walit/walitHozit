//
//  ChatListModel.swift
//  Walt Howzlt
//
//  Created by Arjun on 2/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChatListModel: NSObject {
    var username  : String = ""
    var avatar  : String = ""
    var unread_count  : String = ""
    var last_time  : String = ""
    var time_zone : String = ""
    var receiver_id : String = ""
    var date_time : String = ""
    var message_type : String = ""
    var message : String = " "
    var is_group : String = ""
    var group_id : String = ""
    var thumb = String()
    init (json : [String:JSON])
    {
        thumb = (json["thumb"]?.stringValue)!
        username       = (json["username"]?.stringValue)!
        avatar         = (json["avatar"]?.stringValue)!
        unread_count   = (json["unread_count"]?.stringValue)!
        last_time      = (json["last_time"]?.stringValue)!
        
        time_zone      = (json["time_zone"]?.stringValue)!
        receiver_id    = (json["receiver_id"]?.stringValue)!
        date_time      = (json["date_time"]?.stringValue)!
        message_type   = (json["message_type"]?.stringValue)!
        message        = (json["message"]?.stringValue)!
        is_group       = (json["is_group"]?.stringValue)!
        group_id    =    (json["group_id"]?.stringValue)!
    }
    
}
class ChatModel: NSObject {
    
    var sender_id  : String = ""
    var time_zone : String = ""
    var receiver_id : String = ""
    var date_time : String = ""
    var message_type : String = ""
    var message : String = " "
    var is_read : String = ""
    
    init (json : [String:JSON])
    {
        sender_id      = (json["sender_id"]?.stringValue)!
        time_zone      = (json["time_zone"]?.stringValue)!
        receiver_id    = (json["receiver_id"]?.stringValue)!
        date_time      = (json["date_time"]?.stringValue)!
        message_type   = (json["message_type"]?.stringValue)!
        message        = (json["message"]?.stringValue)!
        is_read        = (json["is_read"]?.stringValue)!
        
    }
    
}
//class StatusListModel: NSObject {
//    var username  : String = ""
//    var myStatus : MyStatus!
//
//    var otherStatus = [OtherStatus]()
//    init (json : [String:JSON])
//    {
//        if let myStatus = (json["mystatus"]?.dictionary){
//            self.myStatus = MyStatus.init(json: myStatus)
//        }
//        if let otherSatus = (json["other_status"]?.array){
//            for item in otherSatus{
//                let dict = item.dictionary
//                self.otherStatus.append(OtherStatus.init(json: dict!))
//            }
//
//        }
//    }
//
//}
