//
//  AboutViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 22/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var viewCustomStatus: UIView!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var tableYConstraint: NSLayoutConstraint!
    var status = String()
    
    
  let arrStatus = ["Hey i'm using walit Howzit",
                  "Available","Busy","At School","At the movies","At work","Battery about to die","In the meeting","At the gym","sleeping","Urgent calls only","Can't talk Howzit only"]
    var selectedIndex  = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.layer.cornerRadius = 4
        txtView.layer.borderColor = UIColor.lightGray.cgColor
        txtView.layer.borderWidth = 0.5
        txtView.clipsToBounds = true
        self.viewCustomStatus.isHidden = true
        self.lblStatus.text = status
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        self.viewCustomStatus.isHidden = false
        tableYConstraint.constant = 67
    }
    
    @IBAction func btnEmoji(_ sender: Any) {
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.view.endEditing(true)
        self.viewCustomStatus.isHidden = true
        if txtView.text == ""  {
            return
        }
        ProfileHandler.shared.updateStatus(status:txtView.text ?? "", completion: {_,_ in
            
        })
        self.lblStatus.text = self.txtView.text
        tableYConstraint.constant = 5
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.viewCustomStatus.isHidden = true
         tableYConstraint.constant = 5
    }
}
extension AboutViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.arrStatus[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        tableView.reloadData()
        self.view.endEditing(true)
        lblStatus.text = arrStatus[indexPath.row]
        ProfileHandler.shared.updateStatus(status:arrStatus[indexPath.row] , completion: {_,_ in 
            
        })
    }
    
    
}
