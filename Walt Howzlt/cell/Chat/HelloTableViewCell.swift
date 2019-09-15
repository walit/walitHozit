//
//  HelloTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class HelloTableViewCell: UITableViewCell {
    @IBOutlet weak var btnHello: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    var callbackhello:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
       self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
        btnHello.layer.cornerRadius = self.btnHello.frame.height / 2
        btnHello.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnHowzit(_ sender: Any) {
        callbackhello?()
    }
}
