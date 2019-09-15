//
//  SatusTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class SatusTableViewCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var callbackEdit : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(myStatus : MyStatus){
       
        
       
        imgview.layer.cornerRadius = imgview.frame.size.width / 2
        imgview.clipsToBounds = true
        lblSubtitle.text = myStatus.created_at
        lblTitle.text = "My Status"
        imgview.layer.borderWidth = 2
        imgview.layer.borderColor = myColors.gradientHigh.cgColor
        
        if myStatus.details.count != 0{
            btnEdit.isHidden = false
            self.btnAdd.isHidden = true
        }else{
            btnEdit.isHidden = true
            self.btnAdd.isHidden = false
        }
        if myStatus.status_type == "image" {
            self.lblMessage.text = ""
            self.imgview.backgroundColor = .white
            let strImage = myStatus.status_images
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imgview.af_setImage(withURL: url)
            }
            else{
                self.imgview.image = #imageLiteral(resourceName: "uploadUser")
            }
        }else if myStatus.status_type == "text" {
            self.lblMessage.text = myStatus.status_text
            self.imgview.backgroundColor = UIColor(hexString: myStatus.status_text_color)
             self.imgview.image = nil
        }else{
            self.lblMessage.text = ""
            let strImage = myStatus.status_images
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imgview.af_setImage(withURL: url)
            }
            else{
                self.imgview.image = #imageLiteral(resourceName: "uploadUser")
            }
        }
    }
    @IBAction func btnEdit(_ sender: Any) {
        callbackEdit?()
    }
    func setOtherStatus(myStatus : OtherStatus){
        let strImage = myStatus.status_images
        print(strImage)
        let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgview.af_setImage(withURL: url)
        }
        else{
            self.imgview.image = #imageLiteral(resourceName: "uploadUser")
        }
        imgview.layer.cornerRadius = imgview.frame.size.width / 2
        imgview.clipsToBounds = true
        lblSubtitle.text = myStatus.created_at
        lblTitle.text = myStatus.name
        imgview.layer.borderWidth = 2
        imgview.layer.borderColor = myColors.gradientHigh.cgColor
        btnEdit.isHidden = true
        self.btnAdd.isHidden = true
        if myStatus.status_type == "image" {
            self.lblMessage.text = ""
            self.imgview.backgroundColor = .white
        }else{
            self.lblMessage.text = myStatus.status_text
            self.imgview.backgroundColor = UIColor(hexString: myStatus.status_text_color)
        }
        //self.setProgress(count: myStatus.details.count, viewimage: imageView ?? UIImageView())
    }
    
//    func setProgress(count :Int,viewimage:UIView){
//        let circlePath = UIBezierPath(ovalIn: viewimage.frame)
//        var segments: [CAShapeLayer] = []
//        let segmentAngle: CGFloat = (360 * 0.125) / 360
//        for i in 1...count - 1{
//            let circleLayer = CAShapeLayer()
//            circleLayer.path = circlePath.cgPath
//
//            // start angle is number of segments * the segment angle
//            circleLayer.strokeStart = segmentAngle * CGFloat(i)
//
//            // end angle is the start plus one segment, minus a little to make a gap
//            // you'll have to play with this value to get it to look right at the size you need
//            let gapSize: CGFloat = 0.008
//            circleLayer.strokeEnd = circleLayer.strokeStart + segmentAngle - gapSize
//
//            circleLayer.lineWidth = 2
//            circleLayer.strokeColor = myColors.gradientLow.cgColor
//            circleLayer.fillColor = UIColor.clear.cgColor
//
//            // add the segment to the segments array and to the view
//            segments.insert(circleLayer, at: i)
//            viewimage.layer.addSublayer(segments[i])
//        }
//
//    }
}
