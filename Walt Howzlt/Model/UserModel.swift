//
//  UserModel.swift
//  Walt Howzlt
//
//  Created by Arjun on 2/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContactModel: NSObject {
     var name               : String = ""
     var access_token               : String = ""
     var email  : String = ""
     var avatar  : String = ""
     var phone  : String = ""
     var last_name  : String = ""
     var other_user_id : String = ""
    
  func getdata (json : [String:JSON]){
        
        other_user_id           = (json["other_user_id"]?.stringValue)!
        name              = (json["other_user_name"]?.stringValue)!
        phone             = (json["phone"]?.stringValue)!
        avatar            = (json["avatar"]?.stringValue)!
    }
}
