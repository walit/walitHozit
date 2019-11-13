//
//  VideoTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 15/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewLeadingConstrints: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstaints: NSLayoutConstraint!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    var callbackPlayVideo :(()->())?
    
    @IBOutlet weak var imgStatus: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.layer.cornerRadius = 5
        viewContainer.clipsToBounds = true
        viewContainer.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.4156862745, blue: 0.2, alpha: 1)
        viewContainer.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(chatItem : ChatModel){
        let strImage = chatItem.message
        
        let dict = convertToArryDictionary(text: strImage)
        if dict == nil {return}
        let url = dict?[0]["thumbnail"] as! String
      
        let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgThumb.af_setImage(withURL: url)
        }
        else{
            self.imgThumb.image = #imageLiteral(resourceName: "uploadUser")
        }
        
        if chatItem.sender_id == Global.sharedInstance.UserID{
            viewLeadingConstrints.priority = UILayoutPriority(rawValue: 250)
            viewTrailingConstaints.priority = UILayoutPriority(rawValue: 999)
        }else{
            viewLeadingConstrints.priority = UILayoutPriority(rawValue: 999)
            viewTrailingConstaints.priority = UILayoutPriority(rawValue: 250)
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.timeZone = TimeZone.current
        if let date = dateFormatterGet.date(from: chatItem.date_time) {
            print()
            self.lblTime.text = dateFormatterPrint.string(from: date.toLocalTime())
            
        } else {
            print("There was an error decoding the string")
        }
        if chatItem.is_read == "1"{
            self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
        }else if chatItem.is_read == "2" {
            self.imgStatus.image = UIImage(named: "right")
        }else{
            self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
        }
        let name = getName(number: chatItem.display_name) == "" ? chatItem.display_name : getName(number: chatItem.display_name)
        
        self.lblTime.text = name  + " " + (self.lblTime.text ?? "")
        
    }
    @IBAction func btnPlayAction(_ sender: Any) {
        callbackPlayVideo?()
    }
    func convertToArryDictionary(text: String) -> [[String: Any]]? {
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                return jsonArray // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
