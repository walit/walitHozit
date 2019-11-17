//
//  LoginHandler.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/30/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginHandler: NSObject {
    func savarserIDAndAccessToken() -> Void {
        let myLoginRecord = NSMutableDictionary()
        myLoginRecord.setObject("1", forKey: myStrings.KLOGIN as NSCopying)
        myLoginRecord.setObject(Global.getUserID(), forKey: myStrings.KUSERID as NSCopying)
        myLoginRecord.setObject(Global.getAccessToken(), forKey: myStrings.KACCESSTOKEN as NSCopying)
        myLoginRecord.setObject(Global.getUserName(), forKey: myStrings.KUSERNAME as NSCopying)
        myLoginRecord.setObject(Global.getUserImage(), forKey: myStrings.KUSERIMAGE as NSCopying)
        
        let defaults = UserDefaults.standard
        defaults.set(myLoginRecord, forKey: myStrings.KUDLOGINSTATUS)
        
    }
    //http://dutimes.in/mobileapp/index.php/apis/login
  
    
    func SignInHandler(deviceID:String,completion:@escaping (_ json: Bool, _ isDisclaimer: Bool, _ error: Error?)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            StaticNameOfVariable.VdeviceID: deviceID,
            "FCM-TOKEN":Global.sharedInstance.FCMToken
        ]
        let param = APIParameter.UserAuth(deviceID: deviceID).dictionary()
        
        APIManager.callApi(API.UserAuth.requestString(), param: param, method:.get, header: headers , encodeType: .default, isLoader: false) { (code, error, json) in
            
            if json != nil
            {
                print(json!)
                let json : JSON = json!
                let code = json.dictionaryValue[StaticNameOfVariable.Vcode]?.intValue
                 let status = json.dictionaryValue[StaticNameOfVariable.VStatus]?.string
                
                if  code == StatusCode.codeOk
                {
                    
                    
                    if status == StatusCode.success{
                        let dict = json.dictionaryValue[StaticNameOfVariable.Vdata]?.dictionaryValue
                        
                        let userID = dict![StaticNameOfVariable.VUserID]?.string
                        Global.setUserID(setUserID:userID!)
                        
                        let fName = dict![StaticNameOfVariable.Vfirstname]?.string
                        let lName = dict![StaticNameOfVariable.Vlastname]?.string
                        Global.setUserName(setUserID: "\(fName!) \(lName!)")
                        
                        let image = dict![StaticNameOfVariable.Vimage]?.string
                        Global.setUserImage(setUserID: image!)
                        
                        let accessToken = dict![StaticNameOfVariable.VAccessToken]?.string
                        Global.setAccessToken(AccessToken: accessToken!)
                        self.savarserIDAndAccessToken()
                        
                        
                        completion(true, false, nil)
                    }else{
                        completion(false, false, nil)
                    }
                   
                }
                else
                {
                    print(json)
                    let errorMessage = json.dictionaryValue[StatusErrorMessade.response_message]?.stringValue
                    Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: errorMessage!)
                    completion(false, false, nil)
                    
                }
            }
        }
    }
    func LoginHandler(email:String,password:String,completion:@escaping (_ json: Bool, _ isDisclaimer: Bool, _ error: Error?)-> Void)
    {
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
       
        let parameters = [
            "username": email,
            "password": password,
            "device": "2",
            "fcm_token": Global.sharedInstance.FCMToken,
            "phone_code": "91",
            "device_id":"1234",
            ] as [String : AnyObject]
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/walitmain/v1/index.php/UserLogin")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.httpBody =  postData as? Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    print(array)
                    if array["status"] as? String == "success"{
                        let dict = array["data"] as? [String: Any]
                        let accesstoken = dict?["access_token"] as? String
                        let first_name = dict?["first_name"] as? String
                        let last_name = dict?["last_name"] as? String
                        
                        let image = dict?["image"] as? String
                        //let phone = array["image"] as? String
                        
                        let user_id = dict?["user_id"] as? String
                         Global.setUserID(setUserID:user_id ?? "")
                         Global.setUserName(setUserID: "\(first_name!) \(last_name!)")
                        Global.setUserImage(setUserID: image!)
                        Global.setAccessToken(AccessToken: accesstoken!)
                        self.savarserIDAndAccessToken()
                         completion(true, false, nil)
                    }else{
                         completion(false, false, nil)
                    }
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
    }
    
}
