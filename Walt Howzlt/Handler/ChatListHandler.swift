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
                print(json!)
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
}
