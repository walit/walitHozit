//
//  ProfileViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 22/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgMan: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStaus: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    ProfileHandler.shared.getuserInfo(userid:Global.sharedInstance.UserID,completion: {succes,json,error in
        print(json)
        DispatchQueue.main.async {
            if let dict = json["data"] as? [String:Any] {
                self.lblName.text  = dict["username"] as? String ?? ""
                self.lblStaus.text  = dict["status"] as? String ?? ""
                self.lblMobileNumber.text = dict["phone"] as? String ?? ""
                let strImage = dict["avatar"] as? String ?? ""
                print(strImage)
                let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgMan.af_setImage(withURL: url)
                }
                else{
                    self.imgMan.image = #imageLiteral(resourceName: "uploadUser")
                }
                self.imgMan.layer.cornerRadius = self.imgMan.frame.size.width / 2
                self.imgMan.clipsToBounds = true
            }
           
        }
    })
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnEdit(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        vc.status = self.lblStaus.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
