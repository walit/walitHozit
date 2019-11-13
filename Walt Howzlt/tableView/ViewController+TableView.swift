//
//  ViewController+TableView.swift
//  Walt Howzlt
//
//  Created by Kavita on 13/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
//MARK: UITableView Method
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       return Global.sharedInstance.indexOfHomeSegment == 0 ? 1 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.sharedInstance.indexOfHomeSegment == 0  {
            if(self.arrChatList.count == 0)
            {
                self.tableView.backgroundView = self.addNoData(message: "No Recents chats available.")
                
            }else{
                self.tableView.backgroundView = nil
            }
            return arrChatList.count
        }else{
            // self.tableView.backgroundView = self.addNoData(message: "No Recents calls available.")
            if myStatus != nil && section == 0{
                return 1
            }else {
                return self.otherStatus.count
            }
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str = "ChatTableViewCell"
        if Global.sharedInstance.indexOfHomeSegment == 0 {
            str = "ChatTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatTableViewCell
            cell.setChatListData(chatList: arrChatList[indexPath.row])
            cell.callbackImageTap = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGroupImageViewController") as! EditGroupImageViewController
                vc.groupImage = self.arrChatList[indexPath.row].thumb
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }else{
            str = "SatusTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! SatusTableViewCell
            if indexPath.section == 0 {
                cell.setData(myStatus: self.myStatus)
                cell.callbackEdit = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditStatusViewController") as! EditStatusViewController
                    vc.details = self.myStatus.details
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                cell.setOtherStatus(myStatus: self.otherStatus[indexPath.row])
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Global.sharedInstance.indexOfHomeSegment == 0{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.reciverID = arrChatList[indexPath.row].receiver_id
            vc.userName = arrChatList[indexPath.row].username
            vc.image = arrChatList[indexPath.row].avatar
            vc.is_group = arrChatList[indexPath.row].is_group
            vc.group_id = arrChatList[indexPath.row].group_id
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if indexPath.section == 0 {
                if self.myStatus.details.count == 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTextStatusViewController") as! CreateTextStatusViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
                    
                    vc.details = self.myStatus.details
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
                
                vc.details = self.otherStatus[indexPath.row].details
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Global.sharedInstance.indexOfHomeSegment == 0{
            return ""
        }else{
            if section == 0 {
                return ""
            }else{
                return "Recent Stories"
            }
            
        }
    }
    
}
