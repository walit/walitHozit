//
//  CreateGroupViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 16/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    @IBOutlet weak var btnNext: UIButton!
    
    var arrContacts = [ContactModel]()
    var selectedContactArr = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
         btnNext.layer.cornerRadius = btnNext.frame.size.width / 2
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext_Action(_ sender: Any) {
        if selectedContactArr.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddGroupViewController") as! AddGroupViewController
            vc.arrContacts = selectedContactArr
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showAlertFor(alertTitle: "Walit", alertMessage: "Please select group member.")
        }
    }
    
}
extension CreateGroupViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = "ContactTableViewCell"
      
        let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ContactTableViewCell
        
        cell.configureCell(contact: arrContacts[indexPath.row])
        if selectedContactArr.contains(arrContacts[indexPath.row]){
            cell.imageCheck.isHidden = false
        }else{
            cell.imageCheck.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedContactArr.contains(arrContacts[indexPath.row]){
            let index  = selectedContactArr.index(of:arrContacts[indexPath.row])
            selectedContactArr.remove(at: index!)
        }else{
            selectedContactArr.append(arrContacts[indexPath.row])
        }
        tableView.reloadData()
        
    }
}
