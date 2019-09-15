//
//  GifTableViewCell.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class GifTableViewCell: UITableViewCell {
    @IBOutlet weak var gifImage: UIImageView!
    
    @IBOutlet weak var imgIncomming: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
