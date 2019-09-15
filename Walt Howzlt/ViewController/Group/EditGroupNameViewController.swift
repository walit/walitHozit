//
//  EditGroupNameViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 27/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class EditGroupNameViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    var groupName = String()
    var group_id  = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = groupName
        self.addDoneButtonOnKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnCancel(_ sender: Any) {
        
    }
    @IBAction func btnOk(_ sender: Any) {
        self.view.endEditing(true)
        GroupInfoHandler.shared.updateGroupName(group_id: self.group_id, group_name: self.txtName.text ?? "", completion: {_,_,_ in
            
        })
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtName.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtName.resignFirstResponder()
    }
}
