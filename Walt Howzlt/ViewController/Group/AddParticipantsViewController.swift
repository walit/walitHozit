//
//  AddParticipantsViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 28/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyContacts
import Contacts
class AddParticipantsViewController: UIViewController {

    @IBOutlet weak var tblview: UITableView!
    var arrContacts = [ContactModel]()
    var contact = ContactHandler()
    var contacts = [CNContact]()
    var groupMember = NSArray()
    var groupId = String()
    var arrSelected = [String]()
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.arrContacts = self.getArray() ?? [ContactModel]()
        if arrContacts.count == 0 {
            self.getContactsAccess()
        }else {
            removeAddedPeople()
        }
        self.tblview.tableFooterView = UIView()
        btnDone.layer.cornerRadius  = btnDone.frame.size.height / 2
        btnDone.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnAdd_action(_ sender: Any) {
        if arrSelected.count > 0 {
            let member  = self.arrSelected.joined(separator: ", ")
            GroupInfoHandler.shared.addGroupMember(group_id: self.groupId, group_member: member, completion: {_,_,_ in
                DispatchQueue.main.async {
                    
                    self.navigationController?.popViewController(animated: true)
                    Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: "", alertMessage: "Member Add Successfully")
                }
            })
        }
    }
    func removeAddedPeople(){
        for item in arrContacts{
            for item1 in groupMember{
                let dict = item1 as? [String:String]
                if dict?["member_id"] == item.other_user_id {
                    self.arrContacts.remove(at: self.arrContacts.firstIndex(of: item)!)
                }
            }
        }
        self.tblview.reloadData()
    }
}
extension AddParticipantsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        cell.configureCell(contact: arrContacts[indexPath.row])
        let id = arrContacts[indexPath.row].other_user_id
        if arrSelected.contains(id) {
                cell.accessoryType = .checkmark
        }else
        {
            cell.accessoryType = .none
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = arrContacts[indexPath.row].other_user_id
        if arrSelected.contains(id){
            self.arrSelected.remove(at: self.arrSelected.firstIndex(of: id)!)
        }else{
            self.arrSelected.append(id)
        }
        self.tblview.reloadData()
    }
}
extension AddParticipantsViewController{
    
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
        
        //        var str = "["
        //
        //        for item in contacts{
        //           var phone = item.phoneNumbers.first?.value.stringValue
        //            phone = phone?.replacingOccurrences(of: "(", with: "")
        //            phone = phone?.replacingOccurrences(of: ")", with: "")
        //            phone = phone?.replacingOccurrences(of: "-", with: "")
        //            phone = phone?.replacingOccurrences(of: " ", with: "")
        //            var numberArray = phone ?? ""
        //            if numberArray.count > 10 {
        //                numberArray = String(numberArray.dropFirst(numberArray.count - 10 ))
        //            }
        //
        //            let strtemp = " {name: \(item.givenName), phone:\(numberArray)} ,";
        //            str.append(strtemp)
        //        }
        //         str = String(str.dropLast())
        //         str.append("]")
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
                    print(jsonResponse)
                    let json =  jsonResponse as? [String : Any]
                    print(json ?? [String : Any]())
                    let arrData = json?["data"] as? NSArray
                    for item in arrData!{
                        let dict = item as?   [String:String]
                        let contact = ContactModel()
                        contact.other_user_id           = (dict?["other_user_id"] ?? "")
                        contact.name              = (dict?["other_user_name"] ?? "")
                        contact.phone             = (dict?["phone"] ?? "")
                        contact.avatar            = (dict?["avatar"] ?? "")
                        self.arrContacts.append(contact)
                    }
                    DispatchQueue.main.async {
                        self.tblview.reloadData()
                        self.convertAndSaveInDDPath(array: self.arrContacts)
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
        
        
        //        contact.contactHandler(json: parameters as [String : AnyObject], completion: {json,success,_ in
        //            if success == true{
        //                self.arrContacts.removeAll()
        //                self.arrContacts = json
        //                self.tableView.reloadData()
        //                self.lblTitle.text = "Select Contacts (\(self.arrContacts.count))"
        //                self.convertAndSaveInDDPath(array: self.arrContacts)
        //             }else{
        //
        //            }
        //
        //        })
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
                contact.other_user_id = patientDict.value(forKey: "other_user_id") as! String
                contact.avatar = patientDict.value(forKey: "avatar") as! String
                patientsArray.append(contact)
                
            }
            return patientsArray
        }
        return nil
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
}
