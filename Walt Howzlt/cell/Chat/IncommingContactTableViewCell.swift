//
//  IncommingContactTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 24/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import MessageUI
class IncommingContactTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var callbackInvite: (()->())?
    var callbackAddConatct: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 4
        viewContainer.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(chatItem:ChatModel){
        let strImage = chatItem.message
        
        let dict = convertToDictionary(text: strImage)
        
        self.lblTitle.text = (dict!["name"] as! String)
      //  lblNumber.text = (dict!["phone"] as! String)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = TimeZone.current
        dateFormatterPrint.dateFormat = "hh:mm a"
        
        if let date = dateFormatterGet.date(from: chatItem.date_time) {
            print()
            self.lblTime.text = dateFormatterPrint.string(from: date.toLocalTime())
            
        } else {
            print("There was an error decoding the string")
        }
    }
    @IBAction func btnInvite(_ sender: Any) {
       self.callbackInvite?()
    }
    
    @IBAction func btnAddContact(_ sender: Any) {
           self.callbackAddConatct?()
    }
   
}

