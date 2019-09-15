//
//  StatusModel.swift
//  Walt Howzlt
//
//  Created by Kavita on 14/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MyStatus {
    var status_images = String()
    var status_type = String()
    var status_text = String()
    var status_text_color = String()
    var created_at = String()
    var name = String()
    var details = [OtherStatus]()
    var current_status_id = String()
    
    init (json : [String:JSON])
    {
        status_images      = (json["status_images"]?.stringValue)!
        status_type      = (json["status_type"]?.stringValue)!
        status_text    = (json["status_text"]?.stringValue)!
        status_text_color      = (json["status_text_color"]?.stringValue)!
        created_at   = (json["created_at"]?.stringValue)!
        current_status_id = (json["current_status_id"]?.stringValue) ?? ""
        name = (json["name"]?.stringValue)!
        if let detials = json["detail"]?.array{
            for item in detials{
                self.details.append(OtherStatus.init(json: item.dictionary!))
            }
        }
        
    }
}
struct OtherStatus {
    var status_images = String()
    var status_type = String()
    var status_text = String()
    var status_text_color = String()
    var created_at = String()
    var name = String()
    
    var current_status_id = String()
    var details = [OtherStatus]()
    init (json : [String:JSON])
    {
        
        status_images      = (json["status_images"]?.stringValue)!
        status_type      = (json["status_type"]?.stringValue)!
        status_text    = (json["status_text"]?.stringValue)!
        status_text_color      = (json["status_text_color"]?.stringValue)!
        name = (json["name"]?.stringValue)!
        created_at   = (json["created_at"]?.stringValue)!
        current_status_id = (json["current_status_id"]?.stringValue)!
        if let detials = json["detail"]?.array{
            for item in detials{
                self.details.append(OtherStatus.init(json: item.dictionary!))
            }
        }
    }
}
