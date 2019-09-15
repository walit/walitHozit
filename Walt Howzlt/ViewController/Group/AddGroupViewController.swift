//
//  AddGroupViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 18/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {
    var arrContacts = [ContactModel]()
    @IBOutlet weak var lblPartciapts: UILabel!
    
    @IBOutlet weak var txtGropuName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgGroup: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPartciapts.text =
        "Participats: \(arrContacts.count)"
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
        if txtGropuName.text?.count == 0{
            showAlertFor(alertTitle: "", alertMessage: "Please enter group Name")
        }else{
            var str = Global.sharedInstance.UserID 
            for item in arrContacts{
             str = str + "," +  item.other_user_id
            }
            print(str)
            GroupChatHandler.shared.createGroup(groupName: txtGropuName.text!, groupmember: "[\(str)]", completion: {_,_ in
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                print("success")
            })
        }
    }
}

extension AddGroupViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrContacts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupMemberCollectionViewCell", for: indexPath) as! GroupMemberCollectionViewCell
        cell.configureCell(contact: arrContacts[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 3 , height: self.view.frame.size.width / 4)
    }
}
