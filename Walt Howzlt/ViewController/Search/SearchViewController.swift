//
//  SearchViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 21/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var arrChatList = [ChatListModel]()
    var arrFilter = [ChatListModel]()
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrFilter  = arrChatList
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
       
    }
}
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilter.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str = "ChatTableViewCell"
        str = "ChatTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatTableViewCell
        cell.setChatListData(chatList: arrFilter[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.reciverID = arrChatList[indexPath.row].receiver_id
        vc.userName = arrChatList[indexPath.row].username
        vc.image = arrChatList[indexPath.row].avatar
        vc.is_group = arrChatList[indexPath.row].is_group
        vc.group_id = arrChatList[indexPath.row].group_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
extension SearchViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.arrFilter.removeAll()
        for item in arrChatList {
            if item.username.contains(text){
                self.arrFilter.append(item)
            }
        }
        self.tableView.reloadData()
        return true
    }
}
