//
//  ViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/5/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Parchment
import SocketIO
import YPImagePicker
class ViewController: UIViewController {
    //IBOutlet
    @IBOutlet weak var btnDailPad: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewChatOption: UIView!
    @IBOutlet weak var viewStatusOption: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    var arrCategoryNames = ["CHAT","STATUS"]
    var segmentedControl = HMSegmentedControl()
    var chatListHandler = ChatListHandler()
    let chooseDropDown = DropDown()
    var myStatus : MyStatus!
    var otherStatus = [OtherStatus]()
    var arrChatList = [ChatListModel]()

    let manager = SocketManager.init(socketURL: URL(string:"http://walit.net:3000")!, config: [.log(true), .compress])
    
    var socket:SocketIOClient!
    var firstTimeLoadData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSocket()
        SetUI()
       // let chat = ChatHandler()
       
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        configreButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getChatList(loader: firstTimeLoadData)
        self.getStatus()
    }
    //MARK: Helper Method
    
    func SetUI(){
        addSegmentedControl()
        setupChooseDropDown()
        
        self.tableView.isHidden = true
        viewStatusOption.isHidden = true
        tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SatusTableViewCell", bundle: nil), forCellReuseIdentifier: "SatusTableViewCell")
      
    }
    func initSocket(){
        socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            self.connectSocket()
        }
    }
    func configreButton(){
        btnDailPad.layer.cornerRadius = btnDailPad.frame.size.height / 2
        btnDailPad.clipsToBounds = true
        btnEdit.layer.cornerRadius = btnEdit.frame.size.height / 2
        btnEdit.clipsToBounds = true
        btnCamera.layer.cornerRadius = btnCamera.frame.size.height / 2
        btnCamera.clipsToBounds = true
    }
    func setupChooseDropDown() {
        chooseDropDown.anchorView = chooseButton
        chooseDropDown.backgroundColor = UIColor.white
      
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: chooseButton.bounds.height)
        
        chooseDropDown.dataSource = [
            "New Group",
            "Profile"
        ]
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseButton.setTitle(item, for: .normal)
            if index == 0{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            else if index == 1{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func addPhotoStatus(){
        var config = YPImagePickerConfiguration()
        config.screens = [.photo,.library]
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateImageStatusViewController") as! CreateImageStatusViewController
                vc.image = photo.image ?? UIImage()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    func addNoData(message:String)->UIView{
        let noData:UILabel = UILabel()
        noData.frame = tableView.bounds
        noData.textAlignment = .center
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.black,
                     NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!]
        noData.attributedText = NSAttributedString(string: message, attributes: attrs)
        return noData
    }
    //MARK: IBAction method
    @IBAction func btnSearch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.arrChatList = self.arrChatList
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func connectSocket(){
        socket.on("recieve message") { (items, ackEmitter) in
            self.getChatList(loader: false)
        }
        
        let dict = [
            "userId" : Global.sharedInstance.UserID,
            ] as? [String: Any]
        
        socket.emit("online", dict!)
        
    }
    @IBAction func btnDailPad(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnShowMenu(_ sender: Any) {
        chooseDropDown.show()
    }
    @IBAction func btnAddTextStatus(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTextStatusViewController") as! CreateTextStatusViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCameraStatus(_ sender: Any) {
        self.addPhotoStatus()
    }
   
}
extension ViewController{
    func addSegmentedControl()
    {
        segmentedControl = HMSegmentedControl(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.width), height: CGFloat(50)))
        segmentedControl.sectionTitles = arrCategoryNames
        segmentedControl.selectedSegmentIndex = Global.sharedInstance.indexOfHomeSegment
        segmentedControl.backgroundColor = UIColor.clear
        
        segmentedControl.titleTextAttributes =  [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 13.0)!
        ]
        segmentedControl.selectedTitleTextAttributes =  [
            NSAttributedString.Key.foregroundColor :UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 13.0)!
        ]
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectionIndicatorColor = myColors.gradientLow
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
        segmentedControl.tag = 3
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
        //view.addSubview(segmentedControl)
        viewSegment.addSubview(segmentedControl)
 }
    
    func addGesture() -> Void {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
       // self.saveTablePosition()
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
//                if Global.sharedInstance.indexOfHomeSegment > 0 {
//                    Global.sharedInstance.indexOfHomeSegment = Global.sharedInstance.indexOfHomeSegment - 1
//                    segmentedControl.setSelectedSegmentIndex(UInt(2), animated: true)
//                    self.transition(3, controller: viewContainer)
//                    //self.setArrayOnIndexChange()
//
//                }
                
                break
                
            case UISwipeGestureRecognizer.Direction.left:
//                if Global.sharedInstance.indexOfHomeSegment < arrCategoryNames.count - 1 {
//                    Global.sharedInstance.indexOfHomeSegment = Global.sharedInstance.indexOfHomeSegment + 1
//                    segmentedControl.setSelectedSegmentIndex(UInt(Global.sharedInstance.indexOfHomeSegment), animated: true)
//                    self.transition(2, controller: viewContainer)
//                    self.setArrayOnIndexChange()
//
//                }
                
                break
                
            default:
                break
            }
        }
    }
    
    @objc func segmentedControlChangedValue(_ segmentedControls: HMSegmentedControl) {
        let selectedSegment = Int(segmentedControls.selectedSegmentIndex)

        if selectedSegment == 0 {
            viewChatOption.isHidden = false
            viewStatusOption.isHidden = true
        }else{
            viewChatOption.isHidden = true
            viewStatusOption.isHidden = false
        }
        
        Global.sharedInstance.indexOfHomeSegment = selectedSegment
        self.tableView.reloadData()
      
    }
    func getChatList(loader:Bool){
        chatListHandler.chatListHandler(loader:loader, completion: {
            arrChatList,success,_ in
             self.tableView.isHidden = false
            if success == true{
                self.firstTimeLoadData = false
                self.arrChatList = arrChatList
                self.tableView.reloadData()
            }
        })
    }
    func getStatus(){
        let ids =  getids()
        chatListHandler.getStatus(loader: false,other_user_ids: ids ,completion: {otherStatus,myStatus,_,_  in
            DispatchQueue.main.async {
                self.myStatus = myStatus
                self.otherStatus = otherStatus
                self.tableView.reloadData()
            }
            
        })
    }
}

extension UITableViewCell{
    func getName(number:String)->String{
        var arrContacts =  [ContactModel]()
        if let json = UserDefaults.standard.value(forKey: "json") as? [String:Any]
        {
            let arrData = json["data"] as? NSArray
            if arrData == nil { return "" }
            for item in arrData!{
                let dict = item as? [String:String]
                let contact = ContactModel()
                contact.other_user_id           = (dict?["other_user_id"] ?? "")
                contact.name              = (dict?["other_user_name"] ?? "")
                contact.phone             = (dict?["phone"] ?? "")
                contact.avatar            = (dict?["avatar"] ?? "")
                arrContacts.append(contact)
            }
        }
        for item in arrContacts{
            if item.phone == number{
                return item.name
            }
        }
         return ""
    }
    
}
extension UIViewController{
    func getName(number:String)->String{
        var arrContacts =  [ContactModel]()
        if let json = UserDefaults.standard.value(forKey: "json") as? [String:Any]
        {
            let arrData = json["data"] as? NSArray
            if arrData == nil { return "" }
            for item in arrData!{
                let dict = item as? [String:String]
                let contact = ContactModel()
                contact.other_user_id           = (dict?["other_user_id"] ?? "")
                contact.name              = (dict?["other_user_name"] ?? "")
                contact.phone             = (dict?["phone"] ?? "")
                contact.avatar            = (dict?["avatar"] ?? "")
                arrContacts.append(contact)
            }
        }
        for item in arrContacts{
            if item.phone == number{
                return item.name
            }
        }
        return ""
    }
    func getids()->String{
        var arrContacts =  [ContactModel]()
        if let json = UserDefaults.standard.value(forKey: "json") as? [String:Any]
        {
            let arrData = json["data"] as? NSArray
            if arrData == nil { return "" }
            for item in arrData!{
                let dict = item as? [String:String]
                let contact = ContactModel()
                contact.other_user_id           = (dict?["other_user_id"] ?? "")
                contact.name              = (dict?["other_user_name"] ?? "")
                contact.phone             = (dict?["phone"] ?? "")
                contact.avatar            = (dict?["avatar"] ?? "")
                arrContacts.append(contact)
            }
        }
        var ids = ""
        
        for (index, item) in arrContacts.enumerated(){
            if index == 0 {
                ids = item.other_user_id
            }else{
                ids = ids + "," + item.other_user_id
            }
        }
        return ids
    }
}
