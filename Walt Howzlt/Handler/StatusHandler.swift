//
//  StatusHandler.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatusHandler: NSObject {
 static let statusHandler = StatusHandler()
    
    func addCurrentStatus(status_type:String,status_text:String,status_text_color:String,image:UIImage?,completion:@escaping ( _ success: Bool,_ message:String ,_ error: Error?)-> Void)
    {
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "access-token": Global.sharedInstance.AccessToken,
            "cache-control": "no-cache",
            "postman-token": "85344bc3-4e36-6dfe-3017-27ddd88a7f2f"
        ]
        let parameters = [
            "status_type": status_type,
            "status_text":status_text,
            "status_text_color":status_text_color,
            ] as [String : Any]
       
        if image == nil {
            self.callMultipartApi("http://walit.net/api/howzit/v1/index.php/AddCurrentStatus", param: parameters as [String : AnyObject], imageArray: nil, method: .post, header: headers, encodeType: .default, videoData: nil, imageNameArray: [], location: true, completionHandler: {code,error,respose in
                if code == 1{
                    //   let message  = respose?["message"].string
                    Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                    
                    completion(true,"",nil)
                    
                    
                }
                
                
            })
        }else{
            self.callMultipartApi("http://walit.net/api/howzit/v1/index.php/AddCurrentStatus", param: parameters as [String : AnyObject], imageArray: [image ?? UIImage()], method: .post, header: headers, encodeType: .default, videoData: nil, imageNameArray: ["status_image"], location: true, completionHandler: {code,error,respose in
                if code == 1{
                    //   let message  = respose?["message"].string
                    Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                    
                    completion(true,"",nil)
                    
                    
                }
                
                
            })
        }
    }
    func callMultipartApi(_ strApiName:String,
                          param : [String : AnyObject]?,
                          imageArray : [UIImage]?,
                          method: HTTPMethod,
                          header:[String : String]?,
                          encodeType:URLEncoding,
                          videoData:NSURL?,
                          imageNameArray:[String]?,location :Bool,
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
                    
                    for i in imageArray ?? [UIImage()]{
                        multipartFormData.append(i.jpegData(compressionQuality: 0.1)!, withName:"status_image", fileName: "\(self.randomString(length: 8)).jpeg", mimeType: "image/jpeg")
                    }
                }
                
                if let param = param{
                    for (key, value) in param {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
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
    func deleteSatus(statusID:String,completion:@escaping ( _ success: Bool,_ jsonResponse:[String:Any] ,_ error: Error?)-> Void)
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
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/index.php/DeleteCurrentStatus?current_status_id=\(statusID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                
            } else {
                
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse)
                    completion(true,jsonResponse as! [String : Any],error)//Response result
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        })
        
        dataTask.resume()
    }
}
