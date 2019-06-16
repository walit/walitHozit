//
//  NSWebSocketManager.swift
//  NSWebSocket
//
//  Created by Nimit IOS on 1/18/18.
//  Copyright © 2018 Nimit IOS. All rights reserved.
//

import Foundation
import Starscream

class NSWebSocketManager: NSObject {
   
    static let sharedInstance = NSWebSocketManager()
    
    var socket =  WebSocket(url: URL(string: "\(myURLs.baseSocketURL)/SetOnline.ashx?")!)

    override init() {
        super.init()
        socket.delegate = self
    }
    
    func establishConnection() {
        
        print("\(myURLs.baseSocketURL)/SetOnline.ashx?UserId:\(Global.getUserID()),IsLogin:1,TimeZone:\(Global.sharedInstance.localTimeZoneName)")
        socket.connect()
    }
    
    func logInCurrentUser() -> Void {
        print("LOGIN CHECK::: UserId:\(Global.getUserID()),IsLogin:1,TimeZone:\(Global.sharedInstance.localTimeZoneName)")
        NSWebSocketManager.sharedInstance.sendMessage("UserId:\(Global.getUserID()),IsLogin:1,TimeZone:\(Global.sharedInstance.localTimeZoneName)")
    }

    func closeConnection() {
        
        print("LOGOUT CHECK::: UserId:\(Global.getUserID()),IsLogin:0")
        NSWebSocketManager.sharedInstance.sendMessage("UserId:\(Global.getUserID()),IsLogin:0")
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    func sendMessage(_ message: String) {
        socket.write(string: message)
    }

}



extension NSWebSocketManager : WebSocketDelegate {
    
    enum NSWebSocketNotificationType: String {
        case NSWebSocketDidConnect
        case NSWebSocketDidDisconnect
        case NSWebSocketDidReceiveMessage
        case NSWebSocketDidReceiveData
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("NSWebSocket Did Connect")

        NSWebSocketManager.sharedInstance.logInCurrentUser()

//        let NSInfo = ["type" : NSWebSocketManager.NSWebSocketNotificationType.NSWebSocketDidConnect, "info" : ""] as [String : Any]
//        let notificationName = Notification.Name("NSWebSocketManagerSOS")
//        NotificationCenter.default.post(name: notificationName, object: NSInfo)

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("NSWebSocket Did Disconnect")
        
//        let NSInfo = ["type" : NSWebSocketManager.NSWebSocketNotificationType.NSWebSocketDidDisconnect, "info" : error!.localizedDescription] as [String : Any]
//        let notificationName = Notification.Name("NSWebSocketManagerSOS")
//        NotificationCenter.default.post(name: notificationName, object: NSInfo)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("NSWebSocket Did Receive Message")
        
//        let NSInfo = ["type" : NSWebSocketManager.NSWebSocketNotificationType.NSWebSocketDidReceiveMessage, "info" : text] as [String : Any]
//        let notificationName = Notification.Name("NSWebSocketManagerSOS")
//        NotificationCenter.default.post(name: notificationName, object: NSInfo)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("NSWebSocket Did Receive Data")
        
//        let NSInfo = ["type" : NSWebSocketManager.NSWebSocketNotificationType.NSWebSocketDidReceiveData, "info" : data] as [String : Any]
//        let notificationName = Notification.Name("NSWebSocketManagerSOS")
//        NotificationCenter.default.post(name: notificationName, object: NSInfo)
    }
    
    
}
