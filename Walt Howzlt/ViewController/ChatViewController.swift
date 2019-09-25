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
import OpalImagePicker
import Photos
import MediaPlayer
import ISEmojiView
import MobileCoreServices

class ChatViewController: UIViewController {
    
    @IBOutlet weak var btnMikeImage: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAttacment: UIView!
    @IBOutlet weak var btnMike: UIButton!
    @IBOutlet weak var bottomConstraint: KeyboardLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtMesageView: NextGrowingTextView!
    @IBOutlet weak var lblStatus: UILabel!

    var keybordHeight : CGFloat = 0.0
    var iskeyBordTypeEmoji = false
    var nodata = false
    var selectedImage: UIImage?
    let chooseDropDown = DropDown()
    var arrChatItem = [ChatModel]()
    var chatHandler = ChatHandler()
    var reciverID = String()
    var group_id = String()
    var is_group = String()
    var userName = String()
    var image = String()
    
    var arrMessage = [String:[ChatModel]]()
    var sectionHeaderArray = [[String: Any]]()
    
    let manager = SocketManager.init(socketURL: URL(string:"http://132.148.145.112:2021")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    let recordingView = SKRecordView(frame: CGRect(x:0, y:UIScreen.main.bounds.height-100 , width:UIScreen.main.bounds.width , height:100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket = manager.defaultSocket
        socket.connect()
        
        configureTableView()
        getMessage()
        setUI()
    }
    override func viewWillLayoutSubviews() {
         self.scrollToBottom()
    }
    func setupRecordView()  {
        recordingView.delegate = self
        recordingView.recordingImages = [UIImage(named: "rec-1.png")!,UIImage(named: "rec-2.png")!,UIImage(named: "rec-3.png")!,UIImage(named: "rec-4.png")!,UIImage(named: "rec-5.png")!,UIImage(named: "rec-6.png")!]
        recordingView.normalImage = UIImage(named: "baseline_mic_black_48")!
        
        view.addSubview(recordingView)
        
        let vConsts = NSLayoutConstraint(item:self.recordingView , attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let hConsts = NSLayoutConstraint(item: self.recordingView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        
        
        view.addConstraints([hConsts])
        view.addConstraints([vConsts])
        ///recordingView.setupRecordingView()
    }
    func setUI(){
         setupChooseDropDown()
         tableView.backgroundView = UIImageView(image: UIImage(named: "chat_background"))
        viewAttacment.isHidden = true
        viewHeight.constant  = 60
        txtMesageView.textView.text = ""
        txtMesageView.textView.delegate = self
        txtMesageView.backgroundColor = .clear
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        self.txtMesageView.placeholderAttributedText = NSAttributedString(
            string: "Type a message",
            attributes: [
                .font: self.txtMesageView.textView.font!,
                .foregroundColor: UIColor.gray
            ]
        )
        setData()
    }
    func configureTableView(){
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "MultiImageTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiImageTableViewCell")
        
        self.tableView.register(UINib(nibName: "GifTableViewCell", bundle: nil), forCellReuseIdentifier: "GifTableViewCell")
        
        self.tableView.register(UINib(nibName: "HelloTableViewCell", bundle: nil), forCellReuseIdentifier: "HelloTableViewCell")
       
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        
        self.tableView.register(UINib(nibName: "IncommingContactTableViewCell", bundle: nil), forCellReuseIdentifier: "IncommingContactTableViewCell")
        
        self.tableView.register(UINib(nibName: "AudioTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioTableViewCell")
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCellell")
        
       // tableView.register(IncommingContactTableViewCell.self, forCellReuseIdentifier: "IncommingContactTableViewCell")
        
        self.tableView.register(UINib(nibName: "DocTableViewCell", bundle: nil), forCellReuseIdentifier: "DocTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected for \(String(describing: self.reciverID))")
            self.connectSocket()
        }
       
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        txtMesageView.maxNumberOfLines = 3
        txtMesageView.textView.clipsToBounds = true
        txtMesageView.clipsToBounds = true
        txtMesageView.showsVerticalScrollIndicator  = false
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.viewHeight.constant = self.txtMesageView.frame.height + 35
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
        self.socket.disconnect()
    }
    //MARK: Helper Method
    func connectSocket(){
        
        if self.group_id == "0"{
            socket.on("online") { (items, ackEmitter) in
                print(items)
                self.setLastSeen(items)
            }
            socket.on("typing") { (items, ackEmitter) in
                print(items)
              
                let dict = items[0] as? [String:Any]
                let receiver_id = dict?["receiver_id"] as? String
                if receiver_id == Global.sharedInstance.UserID
                {
                    self.lblStatus.text = "typing"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.lblStatus.text = "Online"
                    }
                }
                
            }
        }
        
        socket.on("recieve message") { (items, ackEmitter) in
           self.receiveMessage(items: items)
        }
    }
    func setLastSeen(_ items :[Any]){
        if items.count > 0 {
            if let dict = items[0] as? [String:Any]{
                if dict["is_online"] as? String == "Offline"{
                    
                    let online_date_time  = dict["dateTime"] as? String
                    
                    let dateformatter  = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date  = dateformatter.date(from: online_date_time ?? "")
                    dateformatter.dateFormat = "hh:mm a"
                    
                    let diffInDays = dateformatter.string(from: (date?.toLocalTime())!)
                    
                    self.lblStatus.text = "Last seen \(diffInDays) ago"
                    
                }else{
                    self.lblStatus.text = "Online"
                }
            }
        }
    }
    func receiveMessage(items:[Any]){
        for item in items{
            print("socket", item)
            
            let dic = item as! NSDictionary
            
            if dic["is_group"] as? String == "1" {
                if  dic["group_id"] as? String == self.group_id{
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
            }else{
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
    @objc func dismissMyKeyboard() {
        if !self.viewAttacment.isHidden {
             self.viewAttacment.isHidden = true
        }
        
        _ = txtMesageView.resignFirstResponder()
        self.view.endEditing(true)
        
        let modelName = UIDevice.current.modelName
        print(modelName)
        if modelName == "iPhone XS Max" || modelName == "iPhone XS" || modelName == "iPhone X" || modelName == "iPhone XR"{
            self.bottomConstraint.constant =  0
        }else{
            self.bottomConstraint.constant =  0
        }
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion:nil)
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
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.height)
            if point.y >= 0{
                self.tableView.setContentOffset(point, animated: true)
            }
            
        }
    }
    func setupChooseDropDown() {
        chooseDropDown.anchorView = chooseButton
        chooseDropDown.backgroundColor = UIColor.white
        
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: chooseButton.bounds.height)
        
        chooseDropDown.dataSource = [
            "View Info",
            
        ]
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseButton.setTitle(item, for: .normal)
            if self?.is_group == "1"{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
                vc.groupID = self?.group_id ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
                vc.userID = self?.reciverID ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    //MARK: IBAction
    
    
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
        openDocument()
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

    @IBAction func btnAttachment(_ sender: Any) {
        self.bottomConstraint.constant = 0.0
        self.view.endEditing(true)
        if  viewAttacment.isHidden == false{
            viewAttacment.isHidden = true
        }else{
            viewAttacment.isHidden = false
        }
    }
  
    @IBAction func btnGallery_Action(_ sender: Any) {
        self.bottomConstraint.constant = 0.0
        self.view.endEditing(true)
        self.openGallery()
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
      txtMesageView.textView.text  = txtMesageView.textView.text?.trimmingCharacters(in: .whitespaces)
        if (txtMesageView.textView.text?.count)! > 0{
           
            let timezone = Calendar.current.timeZone.abbreviation()!
            print(timezone)
              let messageId = Date().millisecondsSince1970
            let dict = [
                
                "date_time" : self.dateFormat(),
                
                "is_read" : 0,
                
                "message" : txtMesageView.textView.text!,
                
                "message_id" : messageId,
                
                "message_type" : 1,
                
                "receiver_id" : self.reciverID,
                
                "sender_id" : Global.sharedInstance.UserID,
                
                "time_zone" : "IST",
               
                "is_group" : self.group_id == "0" ? "0" : "1",
                "group_id":self.group_id,
                ] as? [String: Any]
            
            socket.emit("send message",dict!)
   
          self.sendData(message_id: "\(messageId)", receiver_id: self.reciverID, message: txtMesageView.textView.text!)
            
        }
    }
    @IBAction func btnInfo_Action(_ sender: Any) {
        if is_group == "1"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
            vc.groupID = self.group_id
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            vc.userID = self.reciverID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: API Calling
extension ChatViewController{
    func getMessage(){
        chatHandler.chatHandler(reciverID:self.reciverID,group_id: self.group_id , completion: {arrMessage,_,_,isOnline,online_date_time  in
            if self.group_id == "0" {
                if isOnline == "Online"{
                    self.lblStatus.text = isOnline
                }else{
                    let dateformatter  = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date  = dateformatter.date(from: online_date_time)
                    
                    dateformatter.dateFormat = "hh:mm a"
                    let diffInDays = dateformatter.string(from: (date?.toLocalTime())!)
                    
                    self.lblStatus.text = "Last seen \(diffInDays) ago"
                }
            }else{
                 self.lblStatus.text = ""
            }
        
            if arrMessage.count > 0 {
               self.arrChatItem = arrMessage
            }else{
                self.nodata = true
            }
            self.udpateData()
        })
    }
    func sendHelloMessage(){
        self.btnMikeImage.setImage(UIImage(named: "baseline_mic_black_48"), for: .normal)
        
        chatHandler.SendHelloMessage(message:"hello", reciverid: self.reciverID,group_id:self.group_id,completion: {_,_ in
            
            let timezone = Calendar.current.timeZone.abbreviation()!
            
            let json = JSON(["receiver_id":self.reciverID,
                             "message": "Hello",
                             "message_type": "5",
                             "group_id" : self.group_id,
                             "date_time": self.dateFormat(),
                             "time_zone": "\(timezone)","is_read": "0",
                             "sender_id":Global.sharedInstance.UserID
                ]).dictionary
            let chatmodel = ChatModel(json: json!)
            self.arrChatItem.append(chatmodel)
            self.udpateData()
        })
    }
    func convertToArryDictionary(text: String) -> [[String: Any]]? {
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                return jsonArray // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
extension ChatViewController: UITextFieldDelegate{

    func dateFormat()-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatterGet.string(from: Date())
    }
    
    func sendData(message_id: String, receiver_id: String,message:String){
        self.btnMikeImage.setImage(UIImage(named: "baseline_mic_black_48"), for: .normal)
        self.txtMesageView.textView.text = ""
        chatHandler.SendMessage(message:message, reciverid: self.reciverID,group_id:self.group_id,completion: {_,_,json in
          
            let timezone = Calendar.current.timeZone.abbreviation()!
            let message_id = json["message_id"] as? String
            let json = JSON(["receiver_id":receiver_id,
                             "message": message,
                              "message_type": "1",
                              "date_time": self.dateFormat(),
                              "time_zone": "\(timezone)","is_read": "0",
                              "message_id":message_id,
                              "is_group" : self.group_id == "0" ? "0" : "1", "sender_id":Global.sharedInstance.UserID,
                              "group_id":self.group_id
            ]).dictionary
            let chatmodel = ChatModel(json: json!)
            self.arrChatItem.append(chatmodel)
            self.udpateData()
         })
        
 }
    func udpateData(){

        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.arrChatItem.count > 0 {
                let indexPath = IndexPath(row: self.arrChatItem.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    func uploadImage(images:[UIImage]){
        chatHandler.uploadImage(image:images, reciverid: self.reciverID,group_id:self.group_id , completion: { rsult,error,json   in
            print(json)
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                let timezone = Calendar.current.timeZone.abbreviation()!
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "2",
                                 "group_id":self.group_id,
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
    func sendLocation(lat:Double,long:Double,Image:UIImage,address:String){
        if is_group == "1"{
            self.reciverID = self.group_id
        }
        chatHandler.uploadlocationImage(image:[self.selectedImage ?? UIImage()],lat: lat,long: long,address: address ,reciverid: self.reciverID,group_id:self.group_id, completion: { rsult,error,json   in
            print(json)
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                let timezone = Calendar.current.timeZone.abbreviation()!
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "4",
                                 "group_id":self.group_id,
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
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 5
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
                                            //Select Assets
                                            var arr = [UIImage]()
                                            for item in assets{
                                             let selectedImage  = self.getUIImage(asset: item)
                                                arr.append(selectedImage!)
                                            }
                                            self.uploadImage(images: arr)
                                            imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
             imagePicker.dismiss(animated: true, completion: nil)
        })
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
        self.uploadImage(images: [selectedImage ?? UIImage()])
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
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
    // MapView Screen shot
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
    
    func playSound(index:Int){
        let strImage = self.arrChatItem[index].message
        let imageview =  UIImageView.init(frame: self.view.frame)
        imageview.backgroundColor = UIColor.darkGray
        imageview.alpha = 0.5
        imageview.isUserInteractionEnabled = true
        self.view.addSubview(imageview)
        let dict = convertToArryDictionary(text: strImage)
        if dict == nil {return}
        let file_url = dict?[0]["file_url"] as! String
        let fileName = dict?[0]["file_name"] as! String
        let myCustomView: AudioPlayView = .fromNib()
        myCustomView.url = file_url
        myCustomView.strFileName = fileName
        myCustomView.initPlayerView()
        myCustomView.callBackFinishPlay = {
            imageview.removeFromSuperview()
        }
        myCustomView.frame = CGRect(x: 20, y: self.view.frame.size.height / 2 - 30, width: self.view.frame.width - 40, height: 100)
        myCustomView.layer.cornerRadius = 5
        myCustomView.clipsToBounds = true
        self.view.addSubview(myCustomView)
    }
    
}
   //MARK:- contact picker
extension ChatViewController: CNContactPickerDelegate{
    func onClickPickContact(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
        
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
        self.dismiss(animated: true, completion: nil)
    }
    func sendContact(name:String,contact:String){
        
        let timezone = Calendar.current.timeZone.abbreviation()!
        
        
        self.chatHandler.SendConatct(name: name, message: contact, reciverid: self.reciverID, group_id: group_id, completion: {_,json in
            
            DispatchQueue.main.async {
               
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": json,
                                 "message_type": "3",
                                 "group_id":self.group_id,
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
    func sendAudioMessage(file:Data){
        
        let timezone = Calendar.current.timeZone.abbreviation()!
        
        chatHandler.uploadFile(file: file, reciverid: self.reciverID, group_id: self.group_id, completion: {_,_,json in
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "3",
                                 "group_id":self.group_id,
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
    func sendDocument(file:Data,filename:String,extention:String){
        
        let timezone = Calendar.current.timeZone.abbreviation()!
        
        chatHandler.uploadDocFile(file: file, extention: extention, name: filename, reciverid: self.reciverID, group_id: self.group_id, completion: {_,_,json in
            let data = json["data"].dictionary
            let message = data?["message"]!.string
            DispatchQueue.main.async {
                let json = JSON(["receiver_id":self.reciverID,
                                 "message": message,
                                 "message_type": "2",
                                 "group_id":self.group_id,
                                 "date_time": self.dateFormat(),
                                 "time_zone": "\(timezone)",
                    "is_read": "0",
                                 "sender_id":Global.sharedInstance.UserID
                    ]).dictionary
                let chatmodel = ChatModel(json: json!)
                self.arrChatItem.append(chatmodel)
                self.udpateData()
            }
        })
        
    }
}
extension ChatViewController :UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
            do {
                let imageData = try Data(contentsOf: myURL as URL)
                self.sendDocument(file: imageData, filename: myURL.lastPathComponent,extention: myURL.pathExtension)
            } catch {
                print("Unable to load data: \(error)")
            }
        
       
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    func openDocument(){
        let types: [String] = [kUTTypePDF as String]
        let importMenu = UIDocumentMenuViewController(documentTypes: types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}
extension ChatViewController : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
       
        let dict = [
            "sender_id" : Global.sharedInstance.UserID,
            "receiver_id" : self.reciverID
            ] as? [String: Any]
        
        socket.emit("typing", dict!)
        
        
        
        txtMesageView.isScrollEnabled = false
        if self.txtMesageView.contentSize.height == 0 {
            viewHeight.constant = 60
        }else{
            viewHeight.constant = self.txtMesageView.contentSize.height + 60
           
        }
        if textView.text == "" {
            self.btnMikeImage.setImage(UIImage(named: "baseline_mic_black_48"), for: .normal)
            
        } else {
            self.btnMikeImage.setImage(UIImage(named: "ic_send_black_xxxhdpi"), for: .normal)
        }
    }
}
extension ChatViewController:SKRecordViewDelegate{
    func SKRecordViewDidSelectRecord(_ sender: SKRecordView, button: UIView) {
        sender.state = .none
        sender.setupRecordButton(UIImage(named: "baseline_mic_black_48")!)
        recordingView.audioRecorder?.stop()
        recordingView.recordButton.imageView?.stopAnimating()
        
        print("Cancelled")
    }
    
    func SKRecordViewDidStopRecord(_ sender: SKRecordView, button: UIView) {
        sender.state = .recording
        sender.setupRecordButton(UIImage(named: "rec-1.png")!)
        sender.audioRecorder?.record()
        recordingView.recordButton.imageView?.startAnimating()
        
        print("Began " + NSUUID().uuidString)
    }
    
    func SKRecordViewDidCancelRecord(_ sender: SKRecordView, button: UIView) {
        recordingView.audioRecorder?.stop()
        
        sender.state = .none
        sender.setupRecordButton(UIImage(named: "baseline_mic_black_48")!)
        print(recordingView.getFileURL())
        recordingView.recordButton.imageView?.stopAnimating()
        
        print("Done")
    }
    
    
}
