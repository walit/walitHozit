//
//  Global.swift
//  Lysten
//
//  Created by owner on 16/11/17.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import SwiftyJSON

class Global: NSObject
{
    static let sharedInstance = Global()
    
    var localTimeZoneName: String { return TimeZone.current.identifier }

    var DeviceToken = String()
    var UserID = String()
    var UserName = String()
    var UserImage = String()
    var FCMToken = String()
    var AccessToken = String()
    var IsAnswered = true

    var arrGAnswers = [JSON]()
    var strGQuestions = String()
    var strGQuestionID = String()
    var strGEventID = String()

    
    var isGFromNotification = Bool()
    var isGAnswer = Bool()
    var isGEvent = Bool()
    var isGCallType = Bool()

    
    var isGIsOwner = Bool()
    var isGIsMember = Bool()
    var isGInbox = Bool()

    var isGGroup = Bool()
    var strGTypeID = String()
    var strGName = String()
    var strGImage = String()
    var strGCallType = String()

    var indexOfGroupSegment = 0
    var indexOfHomeSegment = 0

    
    var isGoToHomeCategories = false
    var isGoToGroupCategories = false

    var isGoToGroupID = String()
    var isGoToHomeID = String()
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 60),
                                                        type: NVActivityIndicatorType.ballPulse)
    
    class func setDeviceToken(DeviceToken : String) -> Void {
        sharedInstance.DeviceToken = DeviceToken
    }
    class func getDeviceToken() -> String {
        return sharedInstance.DeviceToken as String
    }
    
    class func setUserID(setUserID : String) -> Void {
        sharedInstance.UserID = setUserID as String
    }
    
    class func setUserName(setUserID : String) -> Void {
        sharedInstance.UserName = setUserID as String
    }
    class func setUserImage(setUserID : String) -> Void {
        sharedInstance.UserImage = setUserID as String
    }
    
    
    class func getUserID() -> String {
        return sharedInstance.UserID as String
    }
    class func getUserName() -> String {
        return sharedInstance.UserName as String
    }
    class func getUserImage() -> String {
        return sharedInstance.UserImage as String
    }
    class func setAccessToken(AccessToken : String) -> Void {
        sharedInstance.AccessToken = AccessToken
    }
    class func getAccessToken() -> String {
        return sharedInstance.AccessToken as String
    }
}
