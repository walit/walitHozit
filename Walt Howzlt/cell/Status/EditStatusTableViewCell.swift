//
//  EditStatusTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class EditStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var lblShortMEssage: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    var callbackDelete : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(status:OtherStatus){
        self.lblMessage.text = status.created_at
        imageUser.layer.cornerRadius = imageUser.frame.size.width / 2
        imageUser.clipsToBounds = true
        imageUser.contentMode = .scaleAspectFill
       
        if status.status_type == "image" {
            self.lblShortMEssage.text = ""
            self.imageUser.backgroundColor = .white
            let strImage = status.status_images
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imageUser.af_setImage(withURL: url)
            }
            else{
                self.imageUser.image = #imageLiteral(resourceName: "uploadUser")
            }
            
        }else{
            self.lblShortMEssage.text = status.status_text
            self.imageUser.backgroundColor = UIColor(hexString: status.status_text_color)
            imageUser.image = nil
        }
    }
    @IBAction func btnDelete(_ sender: Any) {
        callbackDelete?()
    }
}
