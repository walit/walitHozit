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
    
   var contact = ContactHandler()
   var contacts = [CNContact]()
    var arrContacts = [ContactModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.lblTitle.text = "Select Contacts"
        self.arrContacts = self.getArray() ?? [ContactModel]()
        if arrContacts.count == 0 {
            self.getContactsAccess()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
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
        var arr = [Any]()
        for item in contacts{
            let dict = [ "name" : item.givenName, "phone" : item.phoneNumbers.first?.value.stringValue]
            print(dict)
            arr.append(dict)
        }
        let parameters = ["contacts": arr]
            
        contact.contactHandler(json: parameters, completion: {json,success,_ in
            if success == true{
                self.arrContacts = json
                self.tableView.reloadData()
                self.lblTitle.text = "Select Contacts (\(self.arrContacts.count))"
                self.convertAndSaveInDDPath(array: self.arrContacts)
             }else{
                
            }
            
        })
    }
    
    func getFilePath(fileName:String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileName)?.path
        return filePath!
    }
    
    func convertAndSaveInDDPath (array:[ContactModel]) {
        let objCArray = NSMutableArray()
        for obj in array {
            
            let dict = NSDictionary(objects: [obj.name ,obj.phone,obj.other_user_id,obj.avatar], forKeys: ["name" as NSCopying,"phone" as NSCopying,"other_user_id" as NSCopying,"avatar" as NSCopying])
            objCArray.add(dict)
        }
        
        // this line will save the array in document directory path.
        objCArray.write(toFile: getFilePath(fileName: "contactArray"), atomically: true)
        
    }
    
    func getArray() -> [ContactModel]? {
        var patientsArray = [ContactModel]()
        if let _ = FileManager.default.contents(atPath: getFilePath(fileName: "contactArray")) {
            let array = NSArray(contentsOfFile: getFilePath(fileName: "contactArray"))
            for (_,patientObj) in array!.enumerated() {
                let patientDict = patientObj as! NSDictionary
                let contact = ContactModel()
                
                contact.name = (patientDict.value(forKey: "name") as! String)
                contact.phone = patientDict.value(forKey: "phone") as! String
                contact.phone = patientDict.value(forKey: "other_user_id") as! String
                 contact.avatar = patientDict.value(forKey: "avatar") as! String
                patientsArray.append(contact)
                
            }
            return patientsArray
        }
        return nil
    }
}
