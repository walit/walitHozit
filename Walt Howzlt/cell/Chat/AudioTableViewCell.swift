//
//  AudioTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 15/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var viewGradiant: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var leadingConstaint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstaint: NSLayoutConstraint!
    
    
    
    var callbackPlay : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGradientWithColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func addGradientWithColor(){
        
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = viewGradiant.frame.size
            gradientLayer.colors = [myColors.gradientLow.cgColor, myColors.gradientHigh.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            viewGradiant.layer.insertSublayer(gradientLayer, at: 0)
     }
    func cofigureCell(item :ChatModel){
        if item.message_type == "2" {
            if item.sender_id != Global.sharedInstance.UserID{
                self.imgStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgStatus.image = UIImage(named: "right")
                }else{
                    self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
                
                let dict = convertToArryDictionary(text: strImage)
                if dict == nil {return}
                let fileName = dict?[0]["file_name"] as! String
                self.lblFileName.text = fileName
                let size = dict?[0]["size"] as! String
                self.lblSize.text = size
                leadingConstaint.priority = UILayoutPriority(rawValue: 999)
                 trailingConstaint.priority = UILayoutPriority(rawValue: 250)
            }else{
                self.imgStatus.isHidden = false
                if item.is_read == "1"{
                    self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
                }else if item.is_read == "2" {
                    self.imgStatus.image = UIImage(named: "right")
                }else{
                    self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
                }
                let strImage = item.message
                
                let dict = convertToArryDictionary(text: strImage)
                if dict == nil {return}
                let fileName = dict?[0]["file_name"] as! String
                self.lblFileName.text = fileName
                let size = dict?[0]["size"] as! String
                self.lblSize.text = size
                leadingConstaint.priority = UILayoutPriority(rawValue: 250)
                trailingConstaint.priority = UILayoutPriority(rawValue: 999)
            }
       }
   }
    
    @IBAction func btnPlay(_ sender: Any) {
        callbackPlay?()
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
