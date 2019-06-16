//
//  ChatViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/6/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO
import Alamofire
import ContactsUI
import LocationPicker
import CoreLocation
import MapKit
class ChatViewController: UIViewController {
    
    @IBOutlet weak var btnMikeImage: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAttacment: UIView!
    @IBOutlet weak var btnMike: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var selectedImage: UIImage?
    let chooseDropDown = DropDown()
    var userName = String()
    var image = String()
    var arrChatItem = [ChatModel]()
    var chatHandler = ChatHandler()
    var reciverID = String()
    var arrMessage = [String:[ChatModel]]()
    let manager = SocketManager.init(socketURL: URL(string:"http://132.148.145.112:2021")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    var sectionHeaderArray = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        viewAttacment.isHidden = true
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
         self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCellell")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        setupChooseDropDown()
        
        self.setData()
        self.getMessage()
        socket.connect()
        txtMessage.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected for \(String(describing: self.reciverID))")
            self.connectSocket()
        }
        
        
    }
    @objc func handleKeyboardNotification(notification: NSNotification) {
         
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            let modelName = UIDevice.current.modelName
            print(modelName)
            if modelName == "iPhone XS Max" || modelName == "iPhone XS" || modelName == "iPhone X" || modelName == "iPhone XR"{
                self.bottomConstraint.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : -20
            }else{
                self.bottomConstraint.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            }
            
            
            print("Bottom View Constraint: \(self.bottomConstraint.constant)")
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
            })
            
        }
    }
    func connectSocket(){
       
        socket.on("recieve message") { (items, ackEmitter) in
           
            for item in items{
                print("socket", item)
                let dic = item as! NSDictionary
                if dic["receiver_id"] as? String == Global.sharedInstance.UserID{
                    let json = JSON(["receiver_id":dic["receiver_id"],
                                     "message": dic["message"],
                                     "message_type": dic["message_type"],
                                     "date_time": dic["date_time"],
                                     "time_zone": dic["time_zone"],"is_read": dic["is_read"],
                                     "sender_id":dic["sender_id"]
                        ]).dictionary
                    let chatmodel = ChatModel(json: json!)
                    self.arrChatItem.append(chatmodel)
                    
                    self.udpateData()
                }
               
            }
        }
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.clipsToBounds = true
        
        btnMike.layer.cornerRadius = btnMike.frame.size.height / 2
        btnMike.clipsToBounds = true
        
        imgBg.layer.cornerRadius = 10
        imgBg.clipsToBounds = true
        imgBg.layer.borderWidth = 1
        imgBg.layer.borderColor =  UIColor.darkGray.cgColor
        txtMessage.delegate = self
        txtMessage.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtMessage.frame.height))
        txtMessage.leftViewMode = .always
       // txtMessage.isUserInteractionEnabled = false
     }
    override func viewWillDisappear(_ animated: Bool) {
       
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
        self.socket.disconnect()
    }
    @objc func dismissMyKeyboard() {
        txtMessage.resignFirstResponder()
        self.view.endEditing(true)
        let modelName = UIDevice.current.modelName
        print(modelName)
        if modelName == "iPhone XS Max" || modelName == "iPhone XS" || modelName == "iPhone X" || modelName == "iPhone XR"{
            self.bottomConstraint.constant =  -20
        }else{
            self.bottomConstraint.constant =  0
        }
        
        
        print("Bottom View Constraint: \(self.bottomConstraint.constant)")
        
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            
        })
    }

    func setData(){
       
            lblUserName.text = userName
            let strImage = image
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imgUser.af_setImage(withURL: url)
            }
            else{
                self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
            }
        
        
    }
    @IBAction func btnShowMenu(_ sender: Any) {
        chooseDropDown.show()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGallery(_ sender: Any) {
        viewAttacment.isHidden = true
        openGallery()
    }
    
    
    @IBAction func btnDoucment(_ sender: Any) {
         viewAttacment.isHidden = true
    }
    @IBAction func btnAudio(_ sender: Any) {
         viewAttacment.isHidden = true
    }
    
    
    @IBAction func btnCamera(_ sender: Any) {
        viewAttacment.isHidden = true
        openCamera()
    }
    
    @IBAction func btnLocation(_ sender: Any) {
         viewAttacment.isHidden = true
            getlocation()
    }
    
    @IBAction func btnContacts(_ sender: Any) {
         viewAttacment.isHidden = true
            onClickPickContact()
    }
    
    
    
    func setupChooseDropDown() {
        chooseDropDown.anchorView = chooseButton
        chooseDropDown.backgroundColor = UIColor.white
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: chooseButton.bounds.height)
       
        chooseDropDown.dataSource = [
            "View Contact",
            "Media",
            "Search",
            "Mute notification",
            "Block",
            "Clear Chat",
            "Export Chat",
            "Add",
        ]
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseButton.setTitle(item, for: .normal)
        }
    }
   @objc func keyboardWillShow(notification: Notification) {
    if self.tableView.contentSize.height > self.tableView.frame.size.height
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.size.height)
            if self.bottomConstraint.constant == 0.0 {
                self.bottomConstraint.constant -= keyboardSize.size.height
            }
            
        }
        self.scrollToBottom()
//        UIView.animate(withDuration: 0.0, delay: 0.0, options: [], animations: {
//            DispatchQueue.main.async {
//
//
//            }
//            print("Bottoms up!")
//        }, completion: nil)
    }
        
    }
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.height)
            if point.y >= 0{
                self.tableView.setContentOffset(point, animated: true)
            }
            
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
       self.bottomConstraint.constant = 0.0
    }
    
    @IBAction func btnAttachment(_ sender: Any) {
        if  viewAttacment.isHidden == false{
            viewAttacment.isHidden = true
        }else{
            viewAttacment.isHidden = false
        }
    }
  
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtMessage.text?.count)! > 0{
           
            let timezone = Calendar.current.timeZone.abbreviation()!
            print(timezone)
              let messageId = Date().millisecondsSince1970
            let dict = [
                
                "date_time" : self.dateFormat(),
                
                "is_read" : 0,
                
                "message" : txtMessage.text!,
                
                "message_id" : messageId,
                
                "message_type" : 1,
                
                "receiver_id" : self.reciverID,
                
                "sender_id" : Global.sharedInstance.UserID,
                
                "time_zone" : "IST",
                
                ] as? [String: Any]
            
            socket.emit("send message",dict!)
   
          self.sendData(message_id: "\(messageId)", receiver_id: self.reciverID, message: txtMessage.text!)
            
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            self.btnMikeImage.setImage(UIImage(named: "baseline_mic_black_48"), for: .normal)
            
        } else {
            self.btnMikeImage.setImage(UIImage(named: "ic_send_black_xxxhdpi"), for: .normal)
        }
    }
    @IBAction func txtFieldChaged(_ sender: UITextField) {
        
    }
}
extension ChatViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrChatItem.count
        
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
        if arrChatItem[indexPath.row].message_type == "1"{
            let str = "ChatViewTableViewCell"
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatViewTableViewCell
            cell.configureCell(chatItem: self.arrChatItem[indexPath.row])
             return cell
        }else if arrChatItem[indexPath.row].message_type == "3"{
            
            let str = "ChatContactTableViewCell"
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatContactTableViewCell
            cell.configureCell(chatItem: self.arrChatItem[indexPath.row])
            return cell
            
        }else if arrChatItem[indexPath.row].message_type == "4"{
            
            let str = "LocationTableViewCell"
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! LocationTableViewCell
            cell.configureCell(item: self.arrChatItem[indexPath.row])
            return cell
            
        }else{
            let str = "ChatImageTableViewCell"
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatImageTableViewCell
            cell.configureCell(item: self.arrChatItem[indexPath.row])
            cell.btoutGoing.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell.bntIncomming.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
             cell.btoutGoing.tag = indexPath.row
             cell.bntIncomming.tag = indexPath.row
             return cell
        }
        
   
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrChatItem[indexPath.row].message_type == "1"{
             return UITableView.automaticDimension
        }else if arrChatItem[indexPath.row].message_type == "3"{
            return 110
        }else if arrChatItem[indexPath.row].message_type == "4"{
            return UITableView.automaticDimension
        }else{
             return 200
        }
       
    }
    
    func tableView(_tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
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
   
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        let item = arrChatItem[buttonTag]
        if item.message_type == "2"{
        var strImage = item.message
        strImage = String(strImage.dropLast())
        strImage = String(strImage.dropFirst())
        let dict = convertToDictionary(text: strImage)
        let url = dict!["file_url"] as! String
        let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewViewController")as! ImageViewViewController
        vc.imageview = url
        vc.title = self.userName
        self.navigationController?.pushViewController(vc, animated: true)
        }
     }
}
extension ChatViewController{
    func getMessage(){
        chatHandler.chatHandler(reciverID:self.reciverID , completion: {arrMessage,_,_ in
            if arrMessage.count > 0 {
            
               self.arrChatItem = arrMessage
               self.udpateData()
                
             
            }
        })
    }
    func addData(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var currentDate: String? = nil
        sectionHeaderArray.removeAll()
        var arrMessageItem = [ChatModel]()
        
        for  (index,item) in self.arrChatItem.enumerated() {
            if currentDate == nil {
                // FIRST TIME
                let currentDates = item.date_time.components(separatedBy: " ")
                if currentDates.count > 0 {
                    currentDate = currentDates[0]
                    arrMessageItem.append(item)
                }
               
            } else {
                let currentDates = item.date_time.components(separatedBy: " ")
                if currentDates[0] == currentDate{
                    arrMessageItem.append(item)
                    if index  == self.arrChatItem.count - 1{
                        let dictToAppend: [String : Any] = ["date": currentDates[0], "messages": arrMessageItem]
                        self.sectionHeaderArray.append(dictToAppend)
                    }
                 }else{
                    let dictToAppend: [String : Any] = ["date": currentDates[0], "messages": arrMessageItem]
                    self.sectionHeaderArray.append(dictToAppend)
                    currentDate = currentDates[0]
                    arrMessageItem.removeAll()
                    arrMessageItem.append(item)
                }
            }
            
        }
       
        self.scrollToBottom()
    }
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
extension ChatViewController: UITextFieldDelegate{
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
       
    }

    func dateFormat()-> String{
       
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: Date())
    }
    
    func sendData(message_id: String, receiver_id: String,message:String){
        self.btnMikeImage.setImage(UIImage(named: "baseline_mic_black_48"), for: .normal)
        self.txtMessage.text = ""
        chatHandler.SendMessage(message:message, reciverid: self.reciverID,completion: {_,_ in
          
            let timezone = Calendar.current.timeZone.abbreviation()!

            let json = JSON(["receiver_id":receiver_id,
                             "message": message,
                              "message_type": "1",
                              "date_time": self.dateFormat(),
                              "time_zone": "\(timezone)","is_read": "0",
                              "sender_id":Global.sharedInstance.UserID
            ]).dictionary
            let chatmodel = ChatModel(json: json!)
            self.arrChatItem.append(chatmodel)
            self.udpateData()
         })
        
 }
    func udpateData(){
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//            self.tableView.scrollToBottom(animated:true)
//            //self.getMessage()
//
//        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.arrChatItem.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
extension ChatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            //self.imgUser.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            //self.imgUser.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
        self.uploadImage()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
    }
    func uploadImage(){
        chatHandler.uploadImage(image:self.selectedImage ?? UIImage(), reciverid: self.reciverID , completion: { rsult,error,json   in
            print(json)
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                let timezone = Calendar.current.timeZone.abbreviation()!
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "2",
                                 "date_time": self.dateFormat(),
                                 "time_zone": "\(timezone)","is_read": "0",
                                 "sender_id":Global.sharedInstance.UserID
                    ]).dictionary
                let chatmodel = ChatModel(json: json!)
                self.arrChatItem.append(chatmodel)
                self.udpateData()
            }
        })
        
    }
    func getlocation(){
        self.view.endEditing(true)
        let locationPicker = LocationPickerViewController()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        locationPicker.showCurrentLocationButton = true // default: true
        
        // default: navigation bar's `barTintColor` or `.whiteColor()`
        locationPicker.currentLocationButtonBackground = .blue
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true
        
        locationPicker.mapType = .standard // default: .Hybrid
        
        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false
        
        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
        
        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
        
        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600
        
        locationPicker.completion = { location in
            // do some awesome stuff with location
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.mapScreenshow(lat: location?.location.coordinate.latitude ?? 0.0, long: location?.location.coordinate.longitude ?? 0.0,address:location?.address ?? "")
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    func sendLocation(lat:Double,long:Double,Image:UIImage,address:String){
        chatHandler.uploadlocationImage(image:self.selectedImage ?? UIImage(),lat: lat,long: long,address: address ,reciverid: self.reciverID , completion: { rsult,error,json   in
            print(json)
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                let timezone = Calendar.current.timeZone.abbreviation()!
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "4",
                                 "date_time": self.dateFormat(),
                                 "time_zone": "\(timezone)","is_read": "0",
                                 "sender_id":Global.sharedInstance.UserID
                    ]).dictionary
                let chatmodel = ChatModel(json: json!)
                self.arrChatItem.append(chatmodel)
                self.udpateData()
            }
        })
    }
    func mapScreenshow(lat:Double,long:Double,address:String){
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        // Set the region of the map that is rendered.
        let location = CLLocationCoordinate2DMake(lat, long) // Apple HQ
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 300, height: 300)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start { (snapshot, error) -> Void in
            if error == nil {
                let image = snapshot!.image
                self.selectedImage  = image
                
                
                self.sendLocation(lat: lat, long: long, Image: image,address: address)
            } else {
                print("error")
            }
        }

      
    }
}
extension ChatViewController: CNContactPickerDelegate{
    
    //MARK:- contact picker
    func onClickPickContact(){
        
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user name
        let userName:String = contact.givenName
        
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
    
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        
        print(primaryPhoneNumberStr)
        self.sendContact(name:userName,contact: primaryPhoneNumberStr)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    func sendContact(name:String,contact:String){
        
        let timezone = Calendar.current.timeZone.abbreviation()!
        
        
        self.chatHandler.SendConatct(name: name, message: contact, reciverid: self.reciverID, completion: {_,json in
            
            DispatchQueue.main.async {
               
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": json,
                                 "message_type": "3",
                                 "date_time": self.dateFormat(),
                                 "time_zone": "\(timezone)","is_read": "0",
                                 "sender_id":Global.sharedInstance.UserID
                    ]).dictionary
                let chatmodel = ChatModel(json: json!)
                self.arrChatItem.append(chatmodel)
                self.udpateData()
            }
        })
    }
    
}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
