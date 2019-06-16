//
//  ChatContactTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 14/05/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ChatContactTableViewCell: UITableViewCell {
    @IBOutlet weak var viewoutgoing: UIView!
    
    @IBOutlet weak var imgStatusOutgoing: UIImageView!
    @IBOutlet weak var lblNameoutGoing: UILabel!
    @IBOutlet weak var imgContactOutgoing: UIImageView!
    @IBOutlet weak var viewIncomming: UIView!
    
    @IBOutlet weak var imgStatusIncooming: UIImageView!
    @IBOutlet weak var imgContactIncomming: UIImageView!
    
    @IBOutlet weak var lblNameIncomming: UILabel!
    @IBOutlet weak var lblInTime: UILabel!
    
    @IBOutlet weak var lblOutTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(chatItem:ChatModel){
       
        if chatItem.sender_id == Global.sharedInstance.UserID{
            self.viewoutgoing.isHidden = false
            self.viewIncomming.isHidden = true
            let strImage = chatItem.message
          
            let dict = convertToDictionary(text: strImage)
            
            self.lblNameoutGoing.text = (dict!["name"] as! String)
            self.imgStatusOutgoing.isHidden = false
            if chatItem.is_read == "1"{
                self.imgStatusOutgoing.image = UIImage(named: "ic_done_black_1024dp")
            }else if chatItem.is_read == "2" {
                self.imgStatusOutgoing.image = UIImage(named: "right")
            }else{
                self.imgStatusOutgoing.image = UIImage(named: "ic_done_all_black_48dp")
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "hh:mm a"
            
            if let date = dateFormatterGet.date(from: chatItem.date_time) {
                print()
                self.lblInTime.text = dateFormatterPrint.string(from: date)
                self.lblOutTime.text = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
            
        }else{
            self.viewIncomming.isHidden = false
            self.viewoutgoing.isHidden = true
            
            let strImage = chatItem.message
            
            let dict = convertToDictionary(text: strImage)
            
            self.lblNameIncomming.text = (dict!["name"] as! String)
            self.imgStatusIncooming.isHidden = false
            if chatItem.is_read == "1"{
                self.imgStatusIncooming.image = UIImage(named: "ic_done_black_1024dp")
            }else if chatItem.is_read == "2" {
                self.imgStatusIncooming.image = UIImage(named: "right")
            }else{
                self.imgStatusIncooming.image = UIImage(named: "ic_done_all_black_48dp")
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "hh:mm a"
            
            if let date = dateFormatterGet.date(from: chatItem.date_time) {
                print()
                self.lblInTime.text = dateFormatterPrint.string(from: date)
                self.lblOutTime.text = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
