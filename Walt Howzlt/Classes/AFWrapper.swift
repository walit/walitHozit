//
//  AFWrapper.swift
//  Lysten
//
//  Created by owner on 16/11/17.
//


import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let myURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if Reachability.isConnectedToNetwork() {
            
            //Miscellaneous.APPDELEGATE.window!.makeToastActivity(.center)
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()

            Alamofire.request(myURL!).responseJSON { (responseObject) -> Void in
                //Miscellaneous.APPDELEGATE.window!.hideToastActivity()
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else{
            
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)

        }
    }
    
    class func requestGETURLwithHEADER(_ strURL: String,  params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let myURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if Reachability.isConnectedToNetwork() {
            
            //Miscellaneous.APPDELEGATE.window!.makeToastActivity(.center)
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()

            
            Alamofire.request(myURL!, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
                //Miscellaneous.APPDELEGATE.window!.hideToastActivity()
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else{
            
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)

        }
    }
    
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let myURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if Reachability.isConnectedToNetwork() {
            
            //Miscellaneous.APPDELEGATE.window!.makeToastActivity(.center)
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
            
            Alamofire.request(myURL!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
                
                //Miscellaneous.APPDELEGATE.window!.hideToastActivity()
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else{
            
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)

        }
    }
}
