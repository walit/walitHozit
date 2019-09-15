//
//  ContactViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/6/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyContacts
import Contacts
class ContactViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let chooseDropDown = DropDown()
    var contact = ContactHandler()
    var contacts = [CNContact]()
    var arrContacts = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.lblTitle.text = "Select Contacts"
        //self.arrContacts = self.getArray() ?? [ContactModel]()
        if arrContacts.count == 0 {
            if let json = UserDefaults.standard.value(forKey: "json") as? [String:Any]
            {
                let arrData = json["data"] as? NSArray
                if arrData == nil {return}
                for item in arrData!{
                    let dict = item as? [String:String]
                    let contact = ContactModel()
                    contact.other_user_id           = (dict?["other_user_id"] ?? "")
                    contact.name              = (dict?["other_user_name"] ?? "")
                    contact.phone             = (dict?["phone"] ?? "")
                    contact.avatar            = (dict?["avatar"] ?? "")
                    self.arrContacts.append(contact)
                }
                tableView.reloadData()
            }else{
                self.getContactsAccess()
                self.tableView.reloadData()
            }
            
           
        }
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    @IBAction func btnShowOption(_ sender: UIButton) {
        chooseDropDown.anchorView = sender
        chooseDropDown.backgroundColor = UIColor.white
        
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        
        chooseDropDown.dataSource = [
            "Refresh",
        ]
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.arrContacts.removeAll()
            self?.getContact()
        }
        chooseDropDown.show()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ContactViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContacts.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str = "ContactTableViewCell"
        if indexPath.row  == 0 {
            str = "ContactTableViewCell1"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ContactTableViewCell
            
            return cell
        }else{
            str = "ContactTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ContactTableViewCell
           cell.configureCell(contact: arrContacts[indexPath.row - 1])
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
            vc.arrContacts = arrContacts
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.reciverID = arrContacts[indexPath.row - 1 ].other_user_id
            vc.userName = arrContacts[indexPath.row - 1 ].name
            vc.image = arrContacts[indexPath.row - 1 ].avatar
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
extension ContactViewController{
    
  
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
        

        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
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
                
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                
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
                    let arrData = json?["data"] as? NSArray
                    if arrData == nil {return}
                    for item in arrData!{
                        let dict = item as? [String:String]
                        let contact = ContactModel()
                        contact.other_user_id           = (dict?["other_user_id"] ?? "")
                        contact.name              = (dict?["other_user_name"] ?? "")
                        contact.phone             = (dict?["phone"] ?? "")
                        contact.avatar            = (dict?["avatar"] ?? "")
                        self.arrContacts.append(contact)
                    }
                   
                      self.tableView.reloadData()
                        self.lblTitle.text = "Select Contacts (\(self.arrContacts.count))"
                    
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
            print(convertedString)
            return convertedString ?? ""
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    func getFilePath(fileName:String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileName)?.path
        return filePath!
    }
   
}

