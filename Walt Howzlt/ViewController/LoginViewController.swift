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
import SwiftyContacts
import Contacts

class LoginViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
  
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var contact = ContactHandler()
    var contacts = [CNContact]()
    var arrContacts = [ContactModel]()
    
    @IBOutlet weak var imgbg: UIImageView!
    
    @IBOutlet weak var viewLoader: UIView!
    
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
        btnLogin.titleLabel?.adjustsFontSizeToFitWidth = true
        viewLoader.isHidden = true
        imgbg.isHidden = true
        
        let jeremyGif1 = UIImage.gifImageWithName("loadercontact")
        img.image = jeremyGif1
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnLogin(_ sender: Any) {
        viewLoader.isHidden = false
        imgbg.isHidden = false
        
        self.getContactsAccess()
        
    }
   
    func goToHome(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension LoginViewController{
    
    
    func getContactsAccess(){
        requestAccess { (responce) in
            if responce{
                print("Contacts Acess Granted")
                self.getContact()
            } else {
                print("Contacts Acess Denied")
            }
        }
    }
    func getContact(){
        fetchContacts(completionHandler: { (result) in
            switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array
                self.contacts = contacts
                
                print(self.contacts.count)
                self.sendConatcts()
                break
            case .Error(error: let error):
                print(error)
                break
            }
        })
    }
    
    func sendConatcts(){
        
        let headers = [
            "ACCESS-TOKEN": Global.sharedInstance.AccessToken,
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "d347f3d1-7e97-4823-b873-8989c64d5d66"
        ]
        
        
      //  Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        var str = [[String:String]]()
        
        for item in contacts{
            var phone = item.phoneNumbers.first?.value.stringValue
            phone = phone?.replacingOccurrences(of: "(", with: "")
            phone = phone?.replacingOccurrences(of: ")", with: "")
            phone = phone?.replacingOccurrences(of: "-", with: "")
            phone = phone?.replacingOccurrences(of: " ", with: "")
            var numberArray = phone ?? ""
            if numberArray.count > 10 {
                numberArray = String(numberArray.dropFirst(numberArray.count - 10 ))
            }
            let strtemp = ["name": item.givenName, "phone" : "\(numberArray)"]
            str.append(strtemp)
        }
        
        let parameters = ["contacts": jsonToString(json: str as AnyObject)]
        
        
        print(parameters)
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/howzit/v1/GetContacts")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                //Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    DispatchQueue.main.async {
                        print(jsonResponse)
                        
                        let json =  jsonResponse as? [String : Any]
                        print(json ?? [String : Any]())
                        UserDefaults.standard.set(json, forKey: "json")
                        self.goToHome()
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
                if (error != nil) {
                    print(error!)
                } else {
                    
                }
            })
            
            dataTask.resume()
            
        }catch{
            print(error)
        }
        
    }
    func jsonToString(json: AnyObject)->String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            
            // <-- here is ur string
          //  print(convertedString)
            return convertedString ?? ""
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    
}
