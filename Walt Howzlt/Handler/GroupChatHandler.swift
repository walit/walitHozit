//
//  GroupChatHandler.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
class GroupChatHandler: NSObject {
  static let shared = GroupChatHandler()
    func createGroup(groupName:String,groupmember:[String],selectedImage:UIImage,completion:@escaping ( _ success: Bool, _ error: Error?)-> Void)
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
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/index.php/GroupCreate")! as URL,
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
                    let data = json?["data"] as? [String:Any]
                    let group_id = data?["group_id"] as? String
                    DispatchQueue.main.async {
                       
                        GroupInfoHandler.shared.uplaodImage(image: [selectedImage], group_id: group_id ?? "", completion: {_,_,json in
                            print(json)
                            completion(true, nil)
                        })
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
                
                
                if (error != nil) {
                    print(error!)
                } else {
                   
                 }
            })
            
            dataTask.resume()
            
        }catch{
            print(error)
        }
    }
    
    
    
}
