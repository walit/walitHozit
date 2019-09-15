//
//  GroupMemberCollectionViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class GroupMemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    func configureCell(contact:ContactModel){
        self.lblName.text = contact.name
        let strImage = contact.avatar
        print(strImage)
        let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgUser.af_setImage(withURL: url)
        }
        else{
            self.imgUser.image = #imageLiteral(resourceName: "man (1)")
        }
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
        
    }
}
