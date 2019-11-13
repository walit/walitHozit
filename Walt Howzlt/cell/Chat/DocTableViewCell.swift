//
//  DocTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class DocTableViewCell: UITableViewCell {
    @IBOutlet weak var btnDoc: UIButton!
    @IBOutlet weak var imgeview: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    var callbackOpend:(()->())?
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var trailingConstaint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    
    
    
    @IBAction func btnOpenDoc(_ sender: Any) {
        callbackOpend?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        addGradientWithColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addGradientWithColor(){
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = imgeview.frame.size
        gradientLayer.colors = [myColors.gradientLow.cgColor, myColors.gradientHigh.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        imgeview.layer.insertSublayer(gradientLayer, at: 0)
    }
    func configreCell(chat:ChatModel){
       
        if chat.sender_id == Global.sharedInstance.UserID{
            leadingConstraints.priority = UILayoutPriority(rawValue: 250)
            trailingConstaint.priority = UILayoutPriority(rawValue: 999)
            viewBg.backgroundColor = UIColor(hexString: "FCEBD5")
            
        }else{
            leadingConstraints.priority = UILayoutPriority(rawValue: 999)
            trailingConstaint.priority = UILayoutPriority(rawValue: 250)
            viewBg.backgroundColor = .white
        }
        
        viewBg.layer.cornerRadius = 4
        viewBg.clipsToBounds = true
        
        let strImage = chat.message
        let dict = convertToArryDictionary(text: strImage)
        let filetype = dict![0]["file_name"] as? String
        lblTitle.text = filetype
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.timeZone = TimeZone.current
        if let date = dateFormatterGet.date(from: chat.date_time) {
            print()
            self.lblDate.text = dateFormatterPrint.string(from: date.toLocalTime())
          
        } else {
            print("There was an error decoding the string")
        }
        if chat.is_read == "1"{
            self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
        }else if chat.is_read == "2" {
            self.imgStatus.image = UIImage(named: "right")
        }else{
            self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
        }
        let name = getName(number: chat.display_name) == "" ? chat.display_name : getName(number: chat.display_name)
        
        self.lblDate.text = name  + " " + (self.lblDate.text ?? "")
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
