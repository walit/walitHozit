//
//  participantsTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 27/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class participantsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var groupAdmin: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
