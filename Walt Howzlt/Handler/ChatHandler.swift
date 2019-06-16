//
//  ChatHandler.swift
//  Walt Howzlt
//
//  Created by Arjun on 2/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChatHandler: NSObject {
    var arrChatList = [ChatModel]()
    func chatHandler(reciverID:String,completion:@escaping (_ json: [ChatModel], _ success: Bool, _ error: Error?)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            StaticNameOfVariable.VACCESSTOKEN: Global.sharedInstance.AccessToken
        ]
        let param = APIParameter.GetMessages(receiver_user_id: reciverID).dictionary()
        var loader = true
        if arrChatList.count > 0 {
            loader = false
        }
        APIManager.callApi(API.GetMessages.requestString(), param: param, method:.get, header: headers, encodeType: .default, isLoader: loader) { (code, error, json) in
            
            if json != nil
            {
                //print(json!)
                let json : JSON = json!
                let code = json.dictionaryValue[StaticNameOfVariable.Vcode]?.intValue
                let status = json.dictionaryValue[StaticNameOfVariable.VStatus]?.string
                self.arrChatList.removeAll()
                if  code == StatusCode.codeOk
                {
                    
                    
                    if status == StatusCode.success{
                        let arrData = json.dictionaryValue[StaticNameOfVariable.Vdata]?.arrayValue
                        for item in arrData!{
                            let dict : [String:JSON] = item.dictionaryValue
                            self.arrChatList.append(ChatModel(json: dict))
                        }
                        
                        completion(self.arrChatList, true, nil)
                    }else{
                        completion(self.arrChatList, false, nil)
                    }
                }
                else
                {
                    print(json)
                  
                     Miscellaneous.APPDELEGATE.resetDefaults()
                    
                }
            }
        }
    }
    
    func SendMessage(message:String,reciverid:String,completion:@escaping ( _ success: Bool, _ error: Error?)-> Void)
    {
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
       
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        let messageId = Date().millisecondsSince1970
        let timezone = Calendar.current.timeZone.abbreviation()!
        let parameters = [
            "receiver_user_id": reciverid,
            "message": message,
            "message_type": "1",
            "date_time": self.dateFormat(),
            "time_zone": "\(timezone)",
            "message_id": "\(messageId)",
            "is_read": "0"
            ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://smtgroup.in/walit/howzitapi/index.php/SendMessage")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
               
                
                guard let content = data else {
                    print("not returning data")
                    return
                }
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    print("Not containing JSON")
                    return
                }
                print(json)
                
                
                completion(true, nil)
            }
        })
        
            dataTask.resume()
            
        }catch{
            print(error)
        }
    }
    func dateFormat()-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: Date())
    }
    func uploadImage(image:UIImage,reciverid:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String,_ json : JSON)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
        
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "multipart/form-data",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        let messageId = Date().millisecondsSince1970
        let timezone = Calendar.current.timeZone.abbreviation()!
        let parameters = [
            "receiver_user_id": reciverid,
            "message_type": "2",
            "date_time": self.dateFormat(),
            "time_zone": "\(timezone)",
            "message_id": "\(messageId)",
            
            ] as [String : AnyObject]

        self.callMultipartApi("http://smtgroup.in/walit/howzitapi/index.php/SendFiles", param: parameters, imageArray: [image], method: .post, header: headers, encodeType: .default, videoData: nil, imageNameArray: ["uoload_file[]"], completionHandler: {code,error,respose in
            if code == 1{
                  completion(true,"",respose!)
            }
            
            
            })
    
        
  }
    func uploadlocationImage(image:UIImage,lat:Double,long:Double,address:String,reciverid:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String,_ json : JSON)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
        
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "multipart/form-data",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        let messageId = Date().millisecondsSince1970
        let timezone = Calendar.current.timeZone.abbreviation()!
        let parameters = [
            "receiver_user_id": reciverid,
            "message_type": "4",
            "date_time": self.dateFormat(),
            "time_zone": "\(timezone)",
            "message_id": "\(messageId)",
            "latitude":"\(lat)",
            "longitude":"\(long)",
            "address":address,
            ] as [String : AnyObject]
        
        self.callMultipartApi("http://smtgroup.in/walit/howzitapi/index.php/SendLocation", param: parameters, imageArray: [image], method: .post, header: headers, encodeType: .default, videoData: nil, imageNameArray: ["uoload_file"], completionHandler: {code,error,respose in
            if code == 1{
                completion(true,"",respose!)
            }
            
            
        })
        
        
    }
    func callMultipartApi(_ strApiName:String,
                          param : [String : AnyObject],
                          imageArray : [UIImage]?,
                          method: HTTPMethod,
                          header:[String : String]?,
                          encodeType:URLEncoding,
                          videoData:NSURL?,
                          imageNameArray:[String]?,
                          completionHandler:@escaping SOAPICompletionHandler){
        print("Api Name \(strApiName)")
        print("parameters \(param)")
        
        if Reachability.isConnectedToNetwork(){
            
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if(videoData != nil)
                {
                    var movieData: Data
                    do {
                        movieData = try NSData(contentsOfFile: (videoData?.relativePath!)!, options: NSData.ReadingOptions.alwaysMapped) as Data
                        
                    } catch _ {
                        
                        return
                    }
                    multipartFormData.append(movieData, withName: "Image", fileName: "\(self.randomString(length: 8)).mov", mimeType: "video/mov")
                    
                }
                
                if(imageArray != nil){
                    let imgCount:Int = (imageArray?.count)!
                    for i in 0..<imgCount{
                        multipartFormData.append(imageArray![i].jpegData(compressionQuality: 0.1)!, withName: imageNameArray![i], fileName: "\(self.randomString(length: 8)).jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in param {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to:strApiName,headers: header)
            { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        // print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                        // print("response \(response)")
                        
                        if response.result.isSuccess {
                            let jsonObject = JSON(response.result.value!)
                            completionHandler(1, nil, jsonObject)
                        }
                        else{
                            let error = response.result.error! as NSError
                            completionHandler(0, error, nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                    
                    // print(encodingError)
                    let error = encodingError as NSError
                    completionHandler(0, error, nil)
                }
            }
            
        }else{
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func SendConatct(name:String,message:String,reciverid:String,completion:@escaping ( _ success: Bool, _ message: String)-> Void)
    {
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
        
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        let messageId = Date().millisecondsSince1970
        let timezone = Calendar.current.timeZone.abbreviation()!
        let parameters = [
            "receiver_user_id": reciverid,
            "message": message,
            "message_type": "3",
            "date_time": self.dateFormat(),
            "time_zone": "\(timezone)",
            "message_id": "\(messageId)",
            "is_read": "0",
            "name":name,
         
            ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://smtgroup.in/walit/howzitapi/index.php/SendContactNumber")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    
                    
                    guard let content = data else {
                        print("not returning data")
                        return
                    }
                    guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                        print("Not containing JSON")
                        return
                    }
                    print(json)
                    
                    let message = json["data"] as! NSDictionary
                    completion(true, message.value(forKey: "message") as! String)
                }
            })
            
            dataTask.resume()
            
        }catch{
            print(error)
        }
    }
    func SendLocation(name:String,message:String,reciverid:String,completion:@escaping ( _ success: Bool, _ message: String)-> Void)
    {
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
        
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        let messageId = Date().millisecondsSince1970
        let timezone = Calendar.current.timeZone.abbreviation()!
        let parameters = [
            "receiver_user_id": reciverid,
            "message": message,
            "message_type": "3",
            "date_time": self.dateFormat(),
            "time_zone": "\(timezone)",
            "message_id": "\(messageId)",
            "is_read": "0",
            "name":name,
            
            ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://smtgroup.in/walit/howzitapi/index.php/SendContactNumber")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    
                    
                    guard let content = data else {
                        print("not returning data")
                        return
                    }
                    guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                        print("Not containing JSON")
                        return
                    }
                    print(json)
                    
                    let message = json["data"] as! NSDictionary
                    completion(true, message.value(forKey: "message") as! String)
                }
            })
            
            dataTask.resume()
            
        }catch{
            print(error)
        }
    }
    
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}
extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
