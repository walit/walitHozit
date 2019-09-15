//
//  MultiImageTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 21/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class MultiImageTableViewCell: UITableViewCell {
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var leadingConstaint: NSLayoutConstraint!
    @IBOutlet weak var traingConstraint: NSLayoutConstraint!
    @IBOutlet weak var img1Width: NSLayoutConstraint!
    
    @IBOutlet weak var img1Height: NSLayoutConstraint!
    @IBOutlet weak var img3Width: NSLayoutConstraint!
    @IBOutlet weak var img3Height: NSLayoutConstraint!
    @IBOutlet weak var img4Width: NSLayoutConstraint!
    @IBOutlet weak var img4Height: NSLayoutConstraint!
    @IBOutlet weak var img2Height: NSLayoutConstraint!
    @IBOutlet weak var img2Width: NSLayoutConstraint!
    @IBOutlet weak var btnCount: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    var callBack : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnViewAll(_ sender: Any) {
        callBack?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item:ChatModel){
        if item.sender_id == Global.sharedInstance.UserID{
            self.outGoing()
        }else{
            self.incomming()
        }
        btnCount.isHidden = true
        let strImage = item.message
        
        let dict = convertToArryDictionary(text: strImage)
        if dict == nil {return }
        self.img1.isHidden = true
        self.img2.isHidden = true
        self.img3.isHidden = true
        self.img4.isHidden = true
        if dict?.count == 1{
          self.img4Width =  self.img4Width.setMultiplier(multiplier: 1)
          self.img4Height = self.img4Height.setMultiplier(multiplier: 1)
          let url = dict![0]["thumbnail"] as! String
            self.img4.af_setImage(withURL: self.setImage(url: url)!)
            self.img4.isHidden = false
            
        }else if dict?.count == 2{
         self.img4Width =  self.img4Width.setMultiplier(multiplier: 0.49)
         self.img4Height =  self.img4Height.setMultiplier(multiplier: 1)
         self.img2Width =  self.img2Width.setMultiplier(multiplier: 0.5)
         self.img2Height = self.img2Height.setMultiplier(multiplier: 1)
         var url = dict![0]["thumbnail"] as! String
         self.img4.af_setImage(withURL: self.setImage(url: url)!)
         url = dict![1]["thumbnail"] as! String
         self.img2.af_setImage(withURL: self.setImage(url: url)!)
            self.img4.isHidden = false
            self.img2.isHidden = false
        }else if dict?.count == 3{
            
            if self.img4Width.multiplier != 0.49{
                self.img4Width =  self.img4Width.setMultiplier(multiplier: 0.49)
            }
            if self.img4Height.multiplier != 0.49{
                self.img4Height =  self.img4Height.setMultiplier(multiplier: 0.49)
            }
            if self.img3Width.multiplier != 1{
                self.img3Width =  self.img3Width.setMultiplier(multiplier: 1)
            }
            if self.img3Height.multiplier != 0.5{
               self.img3Height = self.img3Height.setMultiplier(multiplier: 0.5)
            }
            if self.img2Height.multiplier != 0.5{
                self.img2Height =  self.img2Height.setMultiplier(multiplier: 0.5)
            }
            if self.img2Height.multiplier != 0.49{
                self.img2Height =  self.img2Height.setMultiplier(multiplier: 0.49)
            }
            
            var url = dict![0]["thumbnail"] as! String
            self.img4.af_setImage(withURL: self.setImage(url: url)!)
            url = dict![1]["thumbnail"] as! String
            self.img3.af_setImage(withURL: self.setImage(url: url)!)
            url = dict![2]["thumbnail"] as! String
            self.img2.af_setImage(withURL: self.setImage(url: url)!)
            self.img4.isHidden = false
            self.img3.isHidden = false
            self.img2.isHidden = false
        }else{
            
            if self.img4Width.multiplier != 0.5{
                self.img4Width =  self.img4Width.setMultiplier(multiplier: 0.5)
            }
            if self.img4Height.multiplier != 0.5{
                self.img4Height =  self.img4Height.setMultiplier(multiplier: 0.5)
            }
            if self.img3Width.multiplier != 0.5{
                  self.img3Width =  self.img3Width.setMultiplier(multiplier: 0.5)
            }
            if self.img3Width.multiplier != 0.5{
                self.img3Height = self.img3Height.setMultiplier(multiplier: 0.5)
            }
            if self.img2Width.multiplier != 0.5{
                self.img2Width =  self.img2Width.setMultiplier(multiplier: 0.5)
            }
            if self.img2Height.multiplier != 0.5{
               self.img2Height =  self.img2Height.setMultiplier(multiplier: 0.5)
            }
            
            if self.img1Width.multiplier != 0.5{
                self.img1Width =  self.img1Width.setMultiplier(multiplier: 0.5)
            }
            if self.img1Height.multiplier != 0.5{
               self.img1Height =  self.img1Width.setMultiplier(multiplier: 0.5)
            }
            
            var url = dict![0]["thumbnail"] as! String
            self.img4.af_setImage(withURL: self.setImage(url: url)!)
            url = dict![1]["thumbnail"] as! String
            self.img3.af_setImage(withURL: self.setImage(url: url)!)
            url = dict![2]["thumbnail"] as! String
            self.img2.af_setImage(withURL: self.setImage(url: url)!)
            url = dict![3]["thumbnail"] as! String
            self.img1.af_setImage(withURL: self.setImage(url: url)!)
            btnCount.isHidden = false
            let cout = (dict?.count ?? 0) - 4
            if cout > 0 {
              btnCount.setTitle("+\(cout)", for: .normal)
            }else{
              btnCount.setTitle("", for: .normal)
            }
            
            self.img4.isHidden = false
            self.img3.isHidden = false
            self.img2.isHidden = false
            self.img1.isHidden = false
           
        }

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone.current
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.timeZone = TimeZone.current
        if let date = dateFormatterGet.date(from: item.date_time) {
            print()
            self.lblDate.text = dateFormatterPrint.string(from: date.toLocalTime())
            
        } else {
            print("There was an error decoding the string")
        }
        if item.is_read == "1"{
            self.imgStatus.image = UIImage(named: "ic_done_black_1024dp")
        }else if item.is_read == "2" {
            self.imgStatus.image = UIImage(named: "right")
        }else{
            self.imgStatus.image = UIImage(named: "ic_done_all_black_48dp")
        }
    }
    func incomming(){
        leadingConstaint.isActive = true;
        traingConstraint.isActive = true;
        self.leadingConstaint.priority =  UILayoutPriority(999.0)
        self.traingConstraint.priority = UILayoutPriority(250)
    }
    func outGoing(){
        leadingConstaint.isActive = true;
        traingConstraint.isActive = true;
        self.leadingConstaint.priority = UILayoutPriority(rawValue: 250)
        self.traingConstraint.priority = UILayoutPriority(rawValue: 999)
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
    func setImage(url:String) -> URL?{
        
        let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
             return url
        }
        return nil
        
    }
}
extension NSLayoutConstraint {
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
}
