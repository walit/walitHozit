//
//  ChatTableViewCell.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/6/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessageCount: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }
     override func layoutSubviews() {
        super.layoutSubviews()
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setChatListData(chatList:ChatListModel){
        lblMessageCount.layer.cornerRadius = lblMessageCount.bounds.size.height / 2
        lblMessageCount.clipsToBounds = true
        self.lblName.text = chatList.username
        if chatList.message_type == "2"{
             self.lblMessage.text = "Photo"
        }else if chatList.message_type == "3"{
            self.lblMessage.text = "Contact"
        }else if chatList.message_type == "4"{
            let strImage = chatList.message
            let dict = convertToDictionary(text: strImage)
            self.lblMessage.text = dict!["address"] as? String
        }else{
             self.lblMessage.text = chatList.message
        }
       
        let strImage = chatList.thumb
        
        let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgUser.af_setImage(withURL: url)
        }
        else{
            self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        
        if Int(chatList.unread_count)! > 0 {
          lblMessageCount.isHidden = false
          lblMessageCount.text = "\(chatList.unread_count)"
        }else{
            lblMessageCount.isHidden = true
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone =  TimeZone(abbreviation: "UTC")
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterGet.timeZone = TimeZone.current
        dateFormatterPrint.dateFormat = "hh:mm a"
        
        if let date = dateFormatterGet.date(from: chatList.date_time) {
            print()
            self.lblTime.text = dateFormatterPrint.string(from: date.toLocalTime())
            
        } else {
            print("There was an error decoding the string")
        }
    }
    
}
