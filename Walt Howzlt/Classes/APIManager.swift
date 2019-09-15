//
//  APIManager.swift
//  Lysten
//
//  Created by owner on 27/11/17.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

typealias SOAPICompletionHandler = (_ code:Int, _ error:NSError?, _ response:JSON?) -> Void

class APIManager: NSObject {
    
    struct Constants {
        
        static let BASEURL = myURLs.liveURL
        
    }
    
    static var sharedInstance: APIManager = APIManager()
    
    class func callApi(_ strApiName:String,
                       param : [String : AnyObject],
                       method: Alamofire.HTTPMethod,
                       header:[String : String]?,
                       encodeType:URLEncoding,
                       isLoader:Bool,
                       completionHandler:@escaping SOAPICompletionHandler) {
        
        print("Api Name \(strApiName)")
        print("parameters \(param)")
        
        if isLoader == true {
            // For Activity Indicator
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        }
        
       if Reachability.isConnectedToNetwork(){
         
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
        

            manager.request(strApiName, method: method, parameters: param, encoding: encodeType, headers: header).responseJSON { response in
                //debugPrint(response)
                //print("response \(response)")
                if isLoader == true {
                        Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                }
                
                if response.result.isSuccess {
                    let jsonObject = JSON(response.result.value!)
                     print("jsonObject \(jsonObject)")
            
                    completionHandler(1, nil, jsonObject)
                    
                } else {
                    
                    let error = response.result.error! as NSError
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                        completionHandler(0, error, nil)
                        Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.kAlertMsgSomethingWentWrong)

                    }
                    if isLoader == true {
                        Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                    }
                }
            }
        }else{
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
        }
    }
}
//    class func callMultipartApi(_ strApiName:String,
//                                param : [String : AnyObject],
//                                imageArray : [UIImage]?,
//                                method: HTTPMethod,
//                                header:[String : String]?,
//                                encodeType:URLEncoding,
//                                videoData:NSURL?,
//                                imageNameArray:[String]?,
//                                completionHandler:@escaping SOAPICompletionHandler){
//        print("Api Name \(strApiName)")
//        print("parameters \(param)")
//
//        if Reachability.isConnectedToNetwork(){
//
//            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
//
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//
//                if(imageArray != nil){
//                var imgCount:Int = (imageArray?.count)!
//                for i in 0..<imgCount{
////                    multipartFormData.append(UIImageJPEGRepresentation(imageArray![i], 0.5)!, withName: imageNameArray![i], fileName: "\(randomString(length: 8)).jpeg", mimeType: "image/jpeg")
//                }
//                }
//                if(videoData != nil)
//                {
//                    var movieData: Data
//                    do {
//                        movieData = try NSData(contentsOfFile: (videoData?.relativePath!)!, options: NSData.ReadingOptions.alwaysMapped) as Data
//
//                    } catch _ {
//
//                        return
//                    }
//                    multipartFormData.append(movieData, withName: "Image", fileName: "\(randomString(length: 8)).mov", mimeType: "video/mov")
//
//                }
//                for (key, value) in param {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//            }, to:strApiName,headers: header)
//            { (result) in
//
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.uploadProgress(closure: { (Progress) in
//                        // print("Upload Progress: \(Progress.fractionCompleted)")
//                    })
//
//                    upload.responseJSON { response in
//                        Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
//                        // print("response \(response)")
//
//                        if response.result.isSuccess {
//                            let jsonObject = JSON(response.result.value!)
//                            completionHandler(1, nil, jsonObject)
//                        }
//                        else{
//                            let error = response.result.error! as NSError
//                            completionHandler(0, error, nil)
//                        }
//                    }
//
//                case .failure(let encodingError):
//                    Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
//
//                    // print(encodingError)
//                    let error = encodingError as NSError
//                    completionHandler(0, error, nil)
//                }
//            }
//
//        }else{
//            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
//            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
//        }
//    }
    



//func randomString(length: Int) -> String {
//
//    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    let len = UInt32(letters.length)
//
//    var randomString = ""
//
//    for _ in 0 ..< length {
//        let rand = arc4random_uniform(len)
//        var nextChar = letters.character(at: Int(rand))
//        randomString += NSString(characters: &nextChar, length: 1) as String
//    }
//
//    return randomString
//}

enum Response : Int{
    
    case success = 200
    case failure = 400
    
}



enum API {
    
    case UserAuth
    case GetRecentChat
    case GetStatus
    case GetContacts
    case GetMessages
    case SendMessage
    func requestString() -> String {
        
        switch self
        {
        case .UserAuth:
            return APIManager.Constants.BASEURL + ApiNames.VUserAuth
        case .GetRecentChat:
            return APIManager.Constants.BASEURL + ApiNames.VGetRecentChat
        case .GetStatus:
            return APIManager.Constants.BASEURL + ApiNames.VGetStatus
        case .GetContacts:
            return APIManager.Constants.BASEURL + ApiNames.VGetContacts
        case .GetMessages:
            return APIManager.Constants.BASEURL + ApiNames.VGetMessages
        case .SendMessage:
            return APIManager.Constants.BASEURL + ApiNames.VSendMessage
        }
        
    }
}

enum APIParameter {
    
    case UserAuth(deviceID: String)
    case GetRecentChat(ACCESSTOKEN: String)
    case getStatus(ACCESSTOKEN: String)
    case GetContacts(contacts: [String : Any])
    case GetMessages(receiver_user_id: String,group_id:String)
    case SendMessages(receiver_user_id: String,message: String,message_type: String,date_time: String,time_zone: String,is_read:String,message_id:String)
 
    func dictionary() -> Dictionary<String, AnyObject> {
        
        switch self {
        case .UserAuth(deviceID: let deviceID):
            var requestDictionary : Dictionary<String,String> = Dictionary()
            requestDictionary[StaticNameOfVariable.VdeviceID]   = deviceID;
           return requestDictionary as Dictionary<String, AnyObject>
            
        case .GetRecentChat(ACCESSTOKEN: let ACCESSTOKEN):
            var requestDictionary : Dictionary<String,String> = Dictionary()
            requestDictionary[StaticNameOfVariable.VACCESSTOKEN]   = ACCESSTOKEN;
            return requestDictionary as Dictionary<String, AnyObject>
        case .getStatus(ACCESSTOKEN: let ACCESSTOKEN):
            var requestDictionary : Dictionary<String,String> = Dictionary()
            requestDictionary[StaticNameOfVariable.VACCESSTOKEN]   = ACCESSTOKEN;
            return requestDictionary as Dictionary<String, AnyObject>
        case .GetContacts(contacts: let contacts):
            var requestDictionary : Dictionary<String,Any> = Dictionary()
            requestDictionary[StaticNameOfVariable.VContacts]   = contacts;
            return requestDictionary as Dictionary<String, AnyObject>
        case .GetMessages(receiver_user_id:  let receiver_user_id, group_id:  let group_id):
            var requestDictionary : Dictionary<String,Any> = Dictionary()
            requestDictionary[StaticNameOfVariable.VreceiverUserId]   = receiver_user_id;
             requestDictionary["group_id"]   = group_id;
            return requestDictionary as Dictionary<String, AnyObject>
        case .SendMessages(receiver_user_id:  let receiver_user_id, message:  let message, message_type: let message_type, date_time: let date_time, time_zone: let time_zone,is_read:let is_read ,message_id:let message_id):
            var requestDictionary : Dictionary<String,Any> = Dictionary()
            requestDictionary[StaticNameOfVariable.VreceiverUserId]   = receiver_user_id;
             requestDictionary[StaticNameOfVariable.Vmessage]   = message;
             requestDictionary[StaticNameOfVariable.Vmessage_type]   = message_type;
             requestDictionary[StaticNameOfVariable.Vdate_time]   = date_time;
             requestDictionary[StaticNameOfVariable.Vtime_zone]   = time_zone;
            requestDictionary[StaticNameOfVariable.Vmessage_id]   = message_id;
            requestDictionary[StaticNameOfVariable.Vis_read]   = is_read;
            return requestDictionary as Dictionary<String, AnyObject>
            
        }
    
    }
}
    

