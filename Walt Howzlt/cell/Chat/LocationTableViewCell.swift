//
//  LocationTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 15/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var imgIncomming: UIImageView!
    @IBOutlet weak var imgOutGoing: UIImageView!
    @IBOutlet weak var imgoutStatus: UIImageView!
    
    @IBOutlet weak var imgMessageStatus: UIImageView!
    @IBOutlet weak var outCommingView: UIView!
    @IBOutlet weak var imconmingView: UIView!
    
    @IBOutlet weak var lblLocationIn: UILabel!
    @IBOutlet weak var lblInTime: UILabel!
    
    
    @IBOutlet weak var lblLocationOut: UILabel!
    @IBOutlet weak var lblOutTime: UILabel!
    
    @IBOutlet weak var bntIncomming: UIButton!
    
    @IBOutlet weak var btoutGoing: UIButton!
    var callbackMapView:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imconmingView.layer.cornerRadius = 5
        imconmingView.clipsToBounds = true
        imconmingView.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.4156862745, blue: 0.2, alpha: 1)
        imconmingView.layer.borderWidth = 2
        
        outCommingView.layer.cornerRadius = 5
        outCommingView.clipsToBounds = true
        outCommingView.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.4156862745, blue: 0.2, alpha: 1)
        outCommingView.layer.borderWidth = 2
    }
    
    @IBAction func btnMapTapAction(_ sender: Any) {
        callbackMapView?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item :ChatModel){
        if item.message_type == "4" {
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
                if dict == nil {return}
                let url = dict!["file_url"] as! String
                
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgOutGoing.af_setImage(withURL: url)
                }
                else{
                    self.imgOutGoing.image = #imageLiteral(resourceName: "uploadUser")
                }
                self.lblLocationOut.text = (dict!["address"] as! String)
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatterGet.timeZone = TimeZone.current
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                dateFormatterPrint.timeZone = TimeZone.current
                if let date = dateFormatterGet.date(from: item.date_time) {
                    print()
                    self.lblInTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                    self.lblOutTime.text = dateFormatterPrint.string(from: date.toLocalTime())
                } else {
                    print("There was an error decoding the string")
                }
                let name = getName(number: item.display_name) == "" ? item.display_name : getName(number: item.display_name)
                
                self.lblInTime.text = name  + " " + (self.lblInTime.text ?? "")
                self.lblOutTime.text =  self.lblInTime.text
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
                if dict == nil {return}
                let url = dict!["file_url"] as! String
                self.lblLocationIn.text = dict!["address"] as? String
                let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgIncomming.af_setImage(withURL: url)
                }else{
                    self.imgIncomming.image = #imageLiteral(resourceName: "uploadUser")
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatterGet.timeZone = TimeZone.current
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "hh:mm a"
                 dateFormatterPrint.timeZone = TimeZone.current
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
  
}
extension UITableViewCell{
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
