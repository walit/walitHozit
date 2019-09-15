//
//  ParticipantsAddTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 28/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ParticipantsAddTableViewCell: UITableViewCell {
    var callback : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAdd_Action(_ sender: Any) {
        callback?()
    }
    
}
