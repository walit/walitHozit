//
//  ChatImageTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 14/05/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imgIncomming: UIImageView!
    @IBOutlet weak var imgOutGoing: UIImageView!
    @IBOutlet weak var imgoutStatus: UIImageView!
    @IBOutlet weak var imgMessageStatus: UIImageView!
    @IBOutlet weak var outCommingView: UIView!
    @IBOutlet weak var imconmingView: UIView!
    @IBOutlet weak var lblInTime: UILabel!
    @IBOutlet weak var lblOutTime: UILabel!
    @IBOutlet weak var bntIncomming: UIButton!
    @IBOutlet weak var btoutGoing: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item :ChatModel){
        if item.message_type == "2"{
            if item.sender_id != Global.sharedInstance.UserID{
                self.outCommingView.isHidden = false
                imconmingView.isHidden = true
               
                self.imgoutStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgoutStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgoutStatus.image = UIImage(named: "right")
                }else{
                    self.imgoutStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
             
                let dict = convertToArryDictionary(text: strImage)
                let url = dict![0]["file_url"] as! String
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgOutGoing.af_setImage(withURL: url)
                }
                else{
                    self.imgOutGoing.image = #imageLiteral(resourceName: "uploadUser")
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                
                if let date = dateFormatterGet.date(from: item.date_time) {
                    print()
                    self.lblInTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                    self.lblOutTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                } else {
                    print("There was an error decoding the string")
                }
            }else{
                self.imconmingView.isHidden = false
                outCommingView.isHidden = true
                
                self.imgMessageStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgMessageStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgMessageStatus.image = UIImage(named: "right")
                }else{
                    self.imgMessageStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
//                strImage = String(strImage.dropLast())
//                strImage = String(strImage.dropFirst())
                let dict = convertToArryDictionary(text: strImage)
                let url = dict![0]["file_url"] as! String
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgIncomming.af_setImage(withURL: url)
                }
                else{
                    self.imgIncomming.image = #imageLiteral(resourceName: "uploadUser")
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                
                if let date = dateFormatterGet.date(from: item.date_time) {
                    print()
                    self.lblInTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                    self.lblOutTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                } else {
                    print("There was an error decoding the string")
                }
            }
        }else if item.message_type == "4" {
            if item.sender_id != Global.sharedInstance.UserID{
                self.outCommingView.isHidden = false
                imconmingView.isHidden = true
                
                self.imgoutStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgoutStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgoutStatus.image = UIImage(named: "right")
                }else{
                    self.imgoutStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
               
                let dict = convertToDictionary(text: strImage)
                let url = dict!["file_url"] as! String
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgOutGoing.af_setImage(withURL: url)
                }
                else{
                    self.imgOutGoing.image = #imageLiteral(resourceName: "uploadUser")
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                
                if let date = dateFormatterGet.date(from: item.date_time) {
                    print()
                    self.lblInTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                    self.lblOutTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                } else {
                    print("There was an error decoding the string")
                }
            }else{
                self.imconmingView.isHidden = false
                outCommingView.isHidden = true
                
                self.imgMessageStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgMessageStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgMessageStatus.image = UIImage(named: "right")
                }else{
                    self.imgMessageStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
                
                let dict = convertToDictionary(text: strImage)
                let url = dict!["file_url"] as! String
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgIncomming.af_setImage(withURL: url)
                }
                else{
                    self.imgIncomming.image = #imageLiteral(resourceName: "uploadUser")
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                
                if let date = dateFormatterGet.date(from: item.date_time) {
                    print()
                    self.lblInTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                    self.lblOutTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                } else {
                    print("There was an error decoding the string")
                }
            }
            
            
        }
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
