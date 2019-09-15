//
//  GroupChatHandler.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class GroupChatHandler: NSObject {
  static let shared = GroupChatHandler()
    func createGroup(groupName:String,groupmember:String,completion:@escaping ( _ success: Bool, _ error: Error?)-> Void)
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
            "group_name": groupName,
            "group_member": groupmember,
           
            ] as [String : Any]
        print(parameters)
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/GroupCreate")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                
                if (error != nil) {
                    print(error!)
                } else {
                    
                    
//                    guard let content = data else {
//                        print("not returning data")
//                        return
//                    }
//                    guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                        print("Not containing JSON")
//
//                    }
                 //   print(json)
                    
                    
                    completion(true, nil)
                }
            })
            
            dataTask.resume()
            
        }catch{
            print(error)
        }
    }
}
