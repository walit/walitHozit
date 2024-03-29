//
//  ChatListHandler.swift
//  Walt Howzlt
//
//  Created by Arjun on 2/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ChatListHandler: NSObject {
    var arrChatList = [ChatListModel]()
    var arrStatusList = [OtherStatus]()
    var myStatus : MyStatus!
    func chatListHandler(loader:Bool, completion:@escaping (_ json: [ChatListModel], _ success: Bool, _ error: Error?)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            StaticNameOfVariable.VACCESSTOKEN: Global.sharedInstance.AccessToken
        ]
        let param = APIParameter.GetRecentChat(ACCESSTOKEN: Global.sharedInstance.AccessToken).dictionary()
        
         APIManager.callApi(API.GetRecentChat.requestString(), param: param, method:.get, header: headers, encodeType: .default, isLoader: loader) { (code, error, json) in
            
            if json != nil
            {
                print("json! = \(json)")
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
                            self.arrChatList.append(ChatListModel(json: dict))
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
    
    
    
    func getStatus(loader:Bool,other_user_ids:String, completion:@escaping (_ json: [OtherStatus],MyStatus, _ success: Bool, _ error: Error?)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            StaticNameOfVariable.VACCESSTOKEN: Global.sharedInstance.AccessToken
        ]
        let parameters = ["other_user_ids": other_user_ids] as [String : Any]
      
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/index.php/GetCurrentStatusNew")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        request.httpBody = postData as? Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
             do {
            let json = try JSON(data: data)
            if json != nil
            {
                print(json)
                let json : JSON = json
                let code = json.dictionaryValue[StaticNameOfVariable.Vcode]?.intValue
                let status = json.dictionaryValue[StaticNameOfVariable.VStatus]?.string
                self.arrChatList.removeAll()
                if  code == StatusCode.codeOk
                {
                    
                    
                    if status == StatusCode.success{
                        let arrData = json.dictionaryValue[StaticNameOfVariable.Vdata]?.dictionary
                        
                        self.myStatus = MyStatus.init(json:  (arrData?["mystatus"]?.dictionary)!)
                        self.arrStatusList.removeAll()
                        if let arrOther =  arrData?["other_status"]?.array{
                            for item in arrOther{
                                self.arrStatusList.append(OtherStatus.init(json: item.dictionary!))
                            }
                        }
                        
                        completion(self.arrStatusList,self.myStatus, true, nil)
                    }else{
                        completion(self.arrStatusList,self.myStatus, true, nil)
                    }
                }
                else
                {
                    print(json)
                    
                    Miscellaneous.APPDELEGATE.resetDefaults()
                    
                }
                }} catch {
                    print(error)
                    
            }
            
        })
        
        dataTask.resume()
        
       /* APIManager.callApi(API.GetStatus.requestString(), param: param, method:.post, header: headers, encodeType: .default, isLoader: loader) { (code, error, json) in
            
            if json != nil
            {
                print(json!)
                let json : JSON = json!
                let code = json.dictionaryValue[StaticNameOfVariable.Vcode]?.intValue
                let status = json.dictionaryValue[StaticNameOfVariable.VStatus]?.string
                self.arrChatList.removeAll()
                if  code == StatusCode.codeOk
                {
                    
                    
                    if status == StatusCode.success{
                        let arrData = json.dictionaryValue[StaticNameOfVariable.Vdata]?.dictionary
                        
                        self.myStatus = MyStatus.init(json:  (arrData?["mystatus"]?.dictionary)!)
                        self.arrStatusList.removeAll()
                        if let arrOther =  arrData?["other_status"]?.array{
                            for item in arrOther{
                                self.arrStatusList.append(OtherStatus.init(json: item.dictionary!))
                            }
                        }
                        
                        completion(self.arrStatusList,self.myStatus, true, nil)
                    }else{
                        completion(self.arrStatusList,self.myStatus, true, nil)
                    }
                }
                else
                {
                    print(json)
                    
                    Miscellaneous.APPDELEGATE.resetDefaults()
                    
                }
            }
        }*/
    }
  
}
