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
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification
            , object: nil)
        
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
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
                            if self.isMAinAppExist(){
                                self.redirectToMainAppForLogin()
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignINViewController") as! SignINViewController
                                self.navigationController?.pushViewController(vc, animated: true)
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
    func isMAinAppExist() -> Bool{
        let application =  UIApplication.shared;
        if let url = URL.init(string: "walitapp://"){
            return application.canOpenURL(url)
        }
        return false;
    }
    
    func redirectToMainAppForLogin(){
        let application =  UIApplication.shared;
        if let url = URL.init(string: "walitapp://"){
            if application.canOpenURL(url){
                application.open(url, options: [:], completionHandler:nil);
            }
        }
    }
    
    func showAppNotFoundAlert() {
        let alert = UIAlertController(title: "Main application not found", message: "First install and loging it", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { _ in
            exit(0);
            //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "Install", style: .default, handler: {(_: UIAlertAction!) in
            let application =  UIApplication.shared;
            if let url = URL.init(string: "https://apps.apple.com/app/id1475413727"){
                application.openURL(url);
            }
            
        }));
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
   @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.viewDidLoad()
    }
}
