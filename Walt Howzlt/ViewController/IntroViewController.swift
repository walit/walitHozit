//
//  IntroViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/25/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    var loginHandler = LoginHandler()
     let keychain = KeychainSwift()
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain.synchronizable = true
        keychain.accessGroup = "Y3CL89H8DA.com.walitco.WalitHowzlt"
       // print(keychain.get("device_uuid")!)
        
        let jeremyGif = UIImage.gifImageWithName("ezgif.com-gif-maker (2)")
        img.image = jeremyGif
        
        let defaults = UserDefaults.standard
        let dictLogin = defaults.object(forKey: myStrings.KUDLOGINSTATUS) as? NSDictionary
        
        if dictLogin?[myStrings.KLOGIN] != nil{
            let loginStatus = dictLogin?[myStrings.KLOGIN] as! String
            if loginStatus == "1" {
                let userID = dictLogin?[myStrings.KUSERID] as! String
                
                let accessToken = dictLogin?[myStrings.KACCESSTOKEN] as! String
                
                Global.setUserID(setUserID: userID)
                
                Global.setAccessToken(AccessToken: accessToken)
                let image = dictLogin?[myStrings.KUSERIMAGE] as! String
                Global.setUserImage(setUserID: image)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.clearAllFile()
               
                let deviceId = self.keychain.get("device_uuid")
                
                    self.loginHandler.SignInHandler(deviceID: deviceId ?? "", completion: {isValid,_,_ in
                        if isValid == true{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else{
                            //
                            let url = URL(string: "walitapp://")
                            
                            if let url = url {
                                if UIApplication.shared.canOpenURL(url) {
                                    
                                    UIApplication.shared.openURL(url)
                                } else {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignINViewController") as! SignINViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            
                            
                        }
                    })
            }
        }
}
//    func login ()
//    {
//        //let deviceId = UIDevice.current.identifierForVendor?.uuidString
//       let deviceId = keychain.get("device_uuid")
//       
//            self.loginHandler.SignInHandler(deviceID: deviceId ?? "", completion: {isValid,_,_ in
//                if isValid == true{
//                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                }else{
//                  
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignINViewController") as! SignINViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            })
//        
//        
//    }
    func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                try fileManager.removeItem(at: myDocuments)
            } catch {
                return
        }
     }
}
