//
//  Chat+TableView.swift
//  Walt Howzlt
//
//  Created by Kavita on 21/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices
import MessageUI
import Contacts
import ContactsUI
extension ChatViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrChatItem.count == 0 && nodata{
            return 1
        }else{
            return arrChatItem.count
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatHeaderTableViewCell") as! ChatHeaderTableViewCell
    //                let dictInfo = self.arrChatItem[section]
    //                let dateString = dictInfo["date"]
    //                let dateFormatter = DateFormatter()
    //                dateFormatter.dateFormat = "yyyy-MM-dd"
    //                let date = dateFormatter.date(from: dateString as? String ?? "2019-02-17")
    //                dateFormatter.dateFormat = "dd/MM/YY"
    //
    //        cell.lblDate.text = dateFormatter.string(from: date ?? Date()) as? String
    //        return cell
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrChatItem.count == 0{
            let str = "HelloTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! HelloTableViewCell
            cell.callbackhello = {
                self.sendHelloMessage()
            }
            
            let strImage = image
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.imgUser.af_setImage(withURL: url)
            }
            else{
                cell.imgUser.image = #imageLiteral(resourceName: "uploadUser")
            }
            return cell
        }
        if arrChatItem[indexPath.row].message_type == "5"{
            let str = "GifTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! GifTableViewCell
            let jeremyGif = UIImage.gifImageWithName("AFFv")
            if arrChatItem[indexPath.row].sender_id == Global.sharedInstance.UserID{
                cell.gifImage.image = jeremyGif
            }else{
                cell.imgIncomming.image = jeremyGif
            }
            
            return cell
        }else if arrChatItem[indexPath.row].message_type == "1"{
            let str = "ChatViewTableViewCell"
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatViewTableViewCell
            cell.configureCell(chatItem: self.arrChatItem[indexPath.row])
            return cell
        }else if arrChatItem[indexPath.row].message_type == "3"{
            if self.arrChatItem[indexPath.row].sender_id != Global.sharedInstance.UserID{
                let str = "IncommingContactTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! IncommingContactTableViewCell
                 cell.configureCell(chatItem: self.arrChatItem[indexPath.row])
                cell.callbackInvite = {
                    self.sendMessage()
                }
                cell.callbackAddConatct = {
                    self.saveContact(chatItem: self.arrChatItem[indexPath.row])
                }
                return cell
            }else{
                let str = "ChatContactTableViewCell"
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatContactTableViewCell
                cell.configureCell(chatItem: self.arrChatItem[indexPath.row])
                return cell
            }
           
            
        }else if arrChatItem[indexPath.row].message_type == "4"{
            
            let str = "LocationTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! LocationTableViewCell
            cell.configureCell(item: self.arrChatItem[indexPath.row])
            return cell
            
        }else{
            let strImage = self.arrChatItem[indexPath.row].message
            let dict = convertToArryDictionary(text: strImage)
            let filetype = dict![0]["file_type"] as? String
            
             if filetype == "audio" || filetype == "recording"{
                let str = "AudioTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! AudioTableViewCell
                cell.cofigureCell(item: self.arrChatItem[indexPath.row])
                cell.callbackPlay = {
                    self.playSound(index:indexPath.row)
                }
                return cell
            }else if filetype == "photo"{
                let str = "MultiImageTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! MultiImageTableViewCell
                cell.configureCell(item: self.arrChatItem[indexPath.row])
                cell.callBack = {
                    let strImage = self.arrChatItem[indexPath.row].message
                    let dict = self.convertToArryDictionary(text: strImage)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewViewController")as! ImageViewViewController
                    vc.imageview = dict ?? [[String:Any]]()
                    vc.titlestr = self.userName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }else {
                let str = "DocTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! DocTableViewCell
                cell.configreCell(chat: self.arrChatItem[indexPath.row])
                cell.callbackOpend = {
                    let strImage = self.arrChatItem[indexPath.row].message
                    let dict = self.convertToArryDictionary(text: strImage)
                    let filetype = dict![0]["file_url"] as? String
                    let url = URL(string: filetype ?? "https://www.google.com")
                    let vc = SFSafariViewController(url: url!)
                    self.present(vc, animated: true, completion: nil)
                }
                return cell
            }
            
           
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrChatItem.count == 0 {
            return 230
        }
        if arrChatItem[indexPath.row].message_type == "1"{
            return UITableView.automaticDimension
        }else if arrChatItem[indexPath.row].message_type == "3"{
            return 110
        }else if arrChatItem[indexPath.row].message_type == "4"{
            return UITableView.automaticDimension
        }else if arrChatItem[indexPath.row].message_type == "5"{
            return 100
        }else{
            let strImage = self.arrChatItem[indexPath.row].message
            let dict = convertToArryDictionary(text: strImage)
            let filetype = dict![0]["file_type"] as? String
            if filetype == "audio" || filetype == "recording"{
                return 60
            }else if filetype == "photo"{
               return 200
            }else{
                return 80
            }
           
        }
        
    }
    
    func tableView(_tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if arrChatItem.count == 0 {
            return 230
        }
        if arrChatItem[indexPath.row].message_type == "1"{
            return UITableView.automaticDimension
        }else if arrChatItem[indexPath.row].message_type == "3"{
            return 110
        }else if arrChatItem[indexPath.row].message_type == "4"{
            return UITableView.automaticDimension
        }else if arrChatItem[indexPath.row].message_type == "5"{
            return 100
        }else{
            return 200
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
}
extension ChatViewController : MFMessageComposeViewControllerDelegate{
    func sendMessage(){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Share with the people want to get in touch. Get it to free at https://apps.apple.com/us/app/walit/id1475413727?ls=1"
            controller.recipients = [""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    func saveContact(chatItem:ChatModel){
        let strImage = chatItem.message
        let dict = convertToDictionary(text: strImage)
        let name  = (dict!["name"] as! String)
        let number  = (dict!["phone"] as! String)
        let con = CNMutableContact()
        con.givenName = name
        con.familyName = ""
        con.phoneNumbers.append(CNLabeledValue(
            label: name, value: CNPhoneNumber(stringValue: number)))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = ""
        unkvc.contactStore = CNContactStore()
       // unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(unkvc, animated: true)
    }
}
extension ChatViewController{
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
