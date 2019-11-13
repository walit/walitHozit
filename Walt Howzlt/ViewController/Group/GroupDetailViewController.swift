//
//  GroupDetailViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 20/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var lblGroupSubtitle: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblMediaCount: UILabel!
    
    var groupID = String()
    var arrParticipats = NSArray()
    var arrThumbMedia = NSArray()
    var arrMedia = NSArray()
    var isAdmin = String()
    var groupImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(UINib(nibName: "ParticipantsAddTableViewCell", bundle: nil), forCellReuseIdentifier: "ParticipantsAddTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    @IBAction func btnEditGroupImage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGroupImageViewController") as! EditGroupImageViewController
        vc.groupId = self.groupID
        vc.groupImage = self.groupImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGroupNameViewController") as! EditGroupNameViewController
        vc.group_id = self.groupID
        vc.groupName = self.lblTitle.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSwitch(_ sender: Any) {
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnExitGroup(_ sender: Any) {
        GroupInfoHandler.shared.updateGroupMember(group_id: self.groupID, member_id: Global.sharedInstance.UserID, completion: { _,jsonResponse,json in
            print(jsonResponse)
            DispatchQueue.main.async {
                if  jsonResponse["status"] as? String ?? "" != "fail"{
                    self.getData()
                }
                let alert = UIAlertController(title: "", message: jsonResponse["message"] as? String ?? "" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    @IBAction func btn_ReportGroup(_ sender: Any) {
    }
    
}
extension GroupDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrParticipats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantsTableViewCell", for: indexPath) as! participantsTableViewCell
        let item  = arrParticipats[indexPath.row] as? [String:String]
        
        cell.lblName.text = self.getName(number: item?["username"] ?? "")
        if cell.lblName.text == "" {
            cell.lblName.text = item?["username"]
        }
        cell.lblStatus.text = item?["status"]
        let strImage = item?["avatar"]
        
        let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            cell.imgUser.af_setImage(withURL: url)
        }
        else{
            cell.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2
        cell.imgUser.clipsToBounds = true
        
        cell.groupAdmin.layer.borderWidth = 0.5
        cell.groupAdmin.layer.borderColor = cell.lblStatus.textColor.cgColor
        cell.groupAdmin.layer.cornerRadius = 4
        let is_admin = item?["is_admin"]
        cell.groupAdmin.text = " Group Admin "
        if is_admin == "1"{
            cell.groupAdmin .isHidden = false
        }else{
            cell.groupAdmin .isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item  = arrParticipats[indexPath.row] as? [String:String]
        if item?["member_id"] != Global.getUserID(){
            if isAdmin == "0" {
                self.showOtherUserOption(name: item?["username"] ?? "", id: item?["member_id"] ?? "", avatar: item?["avatar"] ?? "")
            }else {
                
                self.showAdminOption(name: item?["username"] ?? "", id: item?["member_id"] ?? "", avatar: item?["avatar"] ?? "", is_admin: item?["is_admin"] ?? "")
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsAddTableViewCell") as! ParticipantsAddTableViewCell
        cell.callback = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddParticipantsViewController") as! AddParticipantsViewController
            vc.groupMember = self.arrParticipats
            vc.groupId = self.groupID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isAdmin == "1" {
            return 54
        }else {
            return 0
        }
        
    }
    func showAdminOption(name:String,id:String,avatar:String,is_admin:String){
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Message \(name)", style: .default , handler:{ (UIAlertAction)in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.reciverID = id
            vc.userName = name
            vc.image = avatar
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "View \(name)", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        if is_admin == "1"{
            alert.addAction(UIAlertAction(title: "Dismiss as Admin", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
                GroupInfoHandler.shared.dismissGroupName(group_id: self.groupID, member_id: id, completion: {_,_,_ in
                    DispatchQueue.main.async {
                        self.getData()
                    }
                })
                
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Make group Admin", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
                GroupInfoHandler.shared.addGroupName(group_id: self.groupID, member_id: id, completion: {_,_,_ in
                    DispatchQueue.main.async {
                        self.getData()
                    }
                })
                
            }))
        }
       
        alert.addAction(UIAlertAction(title: "Remove \(name)", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            GroupInfoHandler.shared.updateGroupMember(group_id: self.groupID, member_id: id, completion: {_,_,_ in
                DispatchQueue.main.async {
                    self.getData()
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func showOtherUserOption(name:String,id:String,avatar:String){
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Message \(name)", style: .default , handler:{ (UIAlertAction)in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.reciverID = id
            vc.userName = name
            vc.image = avatar
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "View \(name)", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
extension GroupDetailViewController{
    func getData(){
        GroupInfoHandler.shared.getGroupInfo(group_id: groupID, completion: {_,json,_ in
            DispatchQueue.main.async {
                print(json)
                
                let data = json["data"] as? NSDictionary
                
                self.lblGroupName.text = data?.value(forKey: "group_name") as? String
                 self.lblTitle.text = data?.value(forKey: "group_name") as? String
                let created_at = data?.value(forKey: "created_at") as? String
                let created_by = data?.value(forKey: "created_by") as? String
                
                self.isAdmin = data?.value(forKey: "is_admin") as? String ?? ""
                
                self.lblGroupSubtitle.text = "Created By \(created_by ?? "") \(created_at ?? "")"
                self.arrParticipats = data?.value(forKey: "group_member") as? NSArray ?? NSArray()
                
                let strImage = data?.value(forKey: "group_img") as? String
                self.groupImage = strImage ?? ""
                let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let url = URL(string: myURL!) {
                    self.imgGroup.af_setImage(withURL: url)
                }
                else{
                    self.imgGroup.image = #imageLiteral(resourceName: "uploadUser")
                }
                self.arrThumbMedia = data?.value(forKey: "media_thumbnail") as? NSArray ?? NSArray()
                
                self.arrMedia = data?.value(forKey: "media") as? NSArray ?? NSArray()
                self.lblMediaCount.text = self.arrMedia.count == 0 ? "" : "\(self.arrMedia.count) >"
                self.tblView.reloadData()
                self.collectionView.reloadData()
            }
            
        })
    }
    
}
extension GroupDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrThumbMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MediaTableViewCell", for: indexPath) as! MediaTableViewCell
        
        
        let strImage = arrThumbMedia[indexPath.row] as? String
       
        let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            cell.image.af_setImage(withURL: url)
        }
        else{
            cell.image.image = #imageLiteral(resourceName: "uploadUser")
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewViewController") as! ImageViewViewController
        vc.arrMedia = self.arrMedia
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
