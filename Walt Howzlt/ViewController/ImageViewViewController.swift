//
//  ImageViewViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 28/05/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class ImageViewViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    var titlestr = String()
    var imageview = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = self.titlestr
        self.imgView.af_setImage(withURL: URL.init(string: self.imageview)!)

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
        // txtMessage.isUserInteractionEnabled = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
