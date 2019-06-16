//
//  LoginViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/7/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import CountryPickerView
import AlamofireImage
class LoginViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
  
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let jeremyGif = UIImage.gifImageWithName("walit-gif")
        imgLogo.image = jeremyGif
        self.btnLogin.layer.cornerRadius = 22
        self.btnLogin.clipsToBounds = true
        lblName.text = Global.sharedInstance.UserName
        let btnTitle = "Continue as \(Global.sharedInstance.UserName)"
        btnLogin.setTitle(btnTitle, for: .normal)
        
        let strImage = Global.sharedInstance.UserImage
        print(strImage)
        let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      
        if let url = URL(string: myURL!) {
            self.imgUser.af_setImage(withURL: url)
        }
        else{
            self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser.clipsToBounds = true
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnLogin(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


