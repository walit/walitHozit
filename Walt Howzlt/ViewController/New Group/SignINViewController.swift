//
//  SignINViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 08/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class SignINViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnRemeber: UIButton!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSmile: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        self.btnLogin.layer.cornerRadius = 22
        self.btnLogin.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnEye(_ sender: Any) {
        if txtPassword.isSecureTextEntry {
            txtPassword.isSecureTextEntry = false
            btnEye.setImage(UIImage(named: "icon_hide_password_green"), for: .normal)
        }else{
            txtPassword.isSecureTextEntry = true
             btnEye.setImage(UIImage(named: "icon_view_password_green"), for: .normal)
        }
    }
    @IBAction func btnRemeber(_ sender: Any) {
        
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if self.isValidEmail(emailStr: txtEmail.text ?? "" ){
            
            if txtPassword.text!.count >= 6{
                self.login()
            }else{
               
                self.showAlertFor(alertTitle: "Error", alertMessage: "Please enter valid password")
            }
        }else{
            if txtEmail.text?.isPhoneNumber ?? false{
                
                if txtPassword.text!.count >= 6{
                    self.login()
                }else{
                    
                    self.showAlertFor(alertTitle: "Error", alertMessage: "Please enter valid password")
                }
                
            }else{
                 self.showAlertFor(alertTitle: "Error", alertMessage: "Please enter vaild username")
            }
           
        }
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtEmail.inputAccessoryView = doneToolbar
        txtPassword.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    func login(){
     let loginHandler =   LoginHandler()
        loginHandler.LoginHandler(email: txtEmail.text ?? "", password: txtPassword.text ?? "", completion: {success,_,_ in
            if success{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
