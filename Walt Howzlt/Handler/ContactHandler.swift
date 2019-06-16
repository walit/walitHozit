//
//  ContactHandler.swift
//  Walt Howzlt
//
//  Created by Arjun on 2/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContactHandler: NSObject {
    var arrContact = [ContactModel]()
    func contactHandler(json:[String:Any] ,completion:@escaping (_ json: [ContactModel], _ success: Bool, _ error: Error?)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            StaticNameOfVariable.VACCESSTOKEN: Global.sharedInstance.AccessToken
        ]
        
        let param = APIParameter.GetContacts(contacts: json).dictionary()
        
        APIManager.callApi(API.GetContacts.requestString(), param: param, method:.post, header: headers, encodeType: .default, isLoader: true) { (code, error, json) in
            
            if json != nil
            {
                print(json!)
                let json : JSON = json!
                let code = json.dictionaryValue[StaticNameOfVariable.Vcode]?.intValue
                let status = json.dictionaryValue[StaticNameOfVariable.VStatus]?.string
                
                if  code == StatusCode.codeOk
                {
                    if status == StatusCode.success{
                        let arrData = json.dictionaryValue[StaticNameOfVariable.Vdata]?.arrayValue
                        for item in arrData!{
                           let dict : [String:JSON] = item.dictionaryValue
                            let contact = ContactModel()
                            contact.other_user_id           = (dict["other_user_id"]!.stringValue)
                            contact.name              = (dict["other_user_name"]!.stringValue)
                            contact.phone             = (dict["phone"]!.stringValue)
                            contact.avatar            = (dict["avatar"]!.stringValue)
                           self.arrContact.append(contact)
                        }
                        
                        completion(self.arrContact, true, nil)
                    }else{
                        completion(self.arrContact, false, nil)
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
