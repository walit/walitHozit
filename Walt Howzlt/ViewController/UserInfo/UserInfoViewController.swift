//
//  UserInfoViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 28/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblMediaCount: UILabel!
    
    var arrCommongroup = NSArray()
    var arrThumbMedia = NSArray()
    var arrMedia = NSArray()
    var userID = String()
    var userimage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileHandler.shared.getuserInfo(userid:userID,completion: {succes,json,error in
            print(json)
            DispatchQueue.main.async {
                if let dict = json["data"] as? [String:Any] {
                    print(dict)
                     self.arrCommongroup = dict["group"] as? NSArray ?? NSArray()
                    
                    self.arrThumbMedia = dict["media_thumbnail"] as? NSArray ?? NSArray()
                    self.arrMedia = dict["media"] as? NSArray ?? NSArray()
                    self.lblMediaCount.text = self.arrMedia.count == 0 ? "" : "\(self.arrMedia.count) >"
                    self.lblName.text = dict["username"] as? String
                    let strImage = dict["avatar"] as? String
                    self.userimage = strImage ?? ""
                    let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    if let url = URL(string: myURL!) {
                        self.imgUser.af_setImage(withURL: url)
                    }
                    else{
                        self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
                    }
                    self.lblNumber.text = dict["phone"] as? String
                    
                    self.tblView.reloadData()
                    self.collectionView.reloadData()
                }
                
            }
        })

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    @IBAction func btnCall(_ sender: Any) {
    }
    @IBAction func btnVidoeCall(_ sender: Any) {
    }
    @IBAction func btnImageExpand(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGroupImageViewController") as! EditGroupImageViewController
        
        vc.groupImage = self.userimage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBlock_Action(_ sender: Any) {
    }
    
    @IBAction func btnReportUser(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UserInfoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCommongroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantsTableViewCell", for: indexPath) as! participantsTableViewCell
        let item  = arrCommongroup[indexPath.row] as? [String:String]
        cell.lblName.text = item?["group_name"]
        let strImage = item?["group_image"]
        
        let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            cell.imgUser.af_setImage(withURL: url)
        }
        else{
            cell.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2
        cell.imgUser.clipsToBounds = true
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension UserInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource{
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
