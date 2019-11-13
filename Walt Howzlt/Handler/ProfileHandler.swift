//
//  ProfileViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 23/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ProfileHandler {
//status
static let shared = ProfileHandler()
func updateStatus(status:String,completion:@escaping ( _ success: Bool, _ error: Error?)-> Void)
{
    
    
    if !Reachability.isConnectedToNetwork()
    {
        Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
        return
    }
    Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
   
    let headers = [
        "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
        "Content-Type": "application/json",
        "cache-control": "no-cache",
        "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
    ]
    
    let parameters = [
        "status": status,
        
        ] as [String : Any]
    do {
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/index.php/UpdateUserStatus")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                let json = jsonResponse as? [String:Any]
                let message = json?["message"] as? String
                 Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: "", alertMessage: message ?? "")
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            if (error != nil) {
                print(error!)
            } else {
               completion(true, nil)
            }
        })
        
        dataTask.resume()
        
    }catch{
        print(error)
    }
}
    func getuserInfo(userid:String,completion:@escaping ( _ success: Bool,_ jsonResponse:[String:Any] ,_ error: Error?)-> Void)
    {
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
       
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        DispatchQueue.main.async {
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        }
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/index.php/GetUserInfo?other_user_id=\(userid)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
             Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            DispatchQueue.main.async {
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            }
            
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse)
                completion(true,jsonResponse as! [String : Any],error)
                //Response result
            } catch let parsingError {
                print("Error", parsingError)
                
            }
        })
        
        dataTask.resume()
    }
}
