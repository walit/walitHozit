//
//  ChatViewTableViewCell.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/7/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ChatViewTableViewCell: UITableViewCell {

    @IBOutlet weak var viewReciver: UIView!
    @IBOutlet weak var viewSender: UIView!
    
    @IBOutlet weak var otherMessage: UILabel!
    
    @IBOutlet weak var lblTImeSender: UILabel!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewReciver.layer.cornerRadius = 5
        viewReciver.clipsToBounds = true
        viewSender.layer.cornerRadius = 5
        viewSender.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(chatItem:ChatModel){
        self.lblMessage.text = chatItem.message
        self.lblTime.text = chatItem.date_time
        if chatItem.sender_id == Global.sharedInstance.UserID{
            viewReciver.isHidden = true
            viewSender.isHidden = false
            lblMessage.text = chatItem.message
            self.lblTime.isHidden = true
            self.lblTImeSender.isHidden = false
            self.imgStatus.isHidden = false
            if chatItem.is_read == "1"{
                self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
            }else if chatItem.is_read == "2" {
                 self.imgStatus.image = UIImage(named: "right")
            }else{
                 self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
            }
        }else{
            viewReciver.isHidden = false
            viewSender.isHidden = true
            otherMessage.text = chatItem.message
            self.lblTime.isHidden = false
            self.lblTImeSender.isHidden = true
            self.imgStatus.isHidden = true
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        
        if let date = dateFormatterGet.date(from: chatItem.date_time) {
            print()
            self.lblTime.text = dateFormatterPrint.string(from: date)
            self.lblTImeSender.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
    }
}

