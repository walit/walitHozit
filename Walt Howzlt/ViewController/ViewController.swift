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

class ViewController: UIViewController {
    
    @IBOutlet weak var btnDailPad: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var viewContainer: UIView!
    var arrCategoryNames = ["CHAT","CALL"]
    var segmentedControl = HMSegmentedControl()
    var chatListHandler = ChatListHandler()
    let chooseDropDown = DropDown()
    var arrChatList = [ChatListModel]()
    let manager = SocketManager.init(socketURL: URL(string:"http://132.148.145.112:2021")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSegmentedControl()
        setupChooseDropDown()
        self.tableView.isHidden = true
        tableView.tableFooterView = UIView()
        socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
           
            self.connectSocket()
        }
        
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
        btnDailPad.layer.cornerRadius = btnDailPad.frame.size.height / 2
        btnDailPad.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getChatList(loader: true)
        
    }
    func connectSocket(){
        
        socket.on("recieve message") { (items, ackEmitter) in
           self.getChatList(loader: false)
        }
    }
    @IBAction func btnDailPad(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnShowMenu(_ sender: Any) {
        chooseDropDown.show()
    }
    func setupChooseDropDown() {
        chooseDropDown.anchorView = chooseButton
        chooseDropDown.backgroundColor = UIColor.white
      
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: chooseButton.bounds.height)
        
        chooseDropDown.dataSource = [
            "New Chat",
            "Setting",
            "Logout"
        ]
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseButton.setTitle(item, for: .normal)
            if index == 2{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
        segmentedControl.selectionIndicatorColor = UIColor.red
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
        segmentedControl.tag = 3
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
        //view.addSubview(segmentedControl)
        viewSegment.addSubview(segmentedControl)
        
       // self.setArrayOnIndexChange()
        
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
        
        //self.saveTablePosition()
        
        let selectedSegment = Int(segmentedControls.selectedSegmentIndex)
        
//        if selectedSegment > Global.sharedInstance.indexOfHomeSegment {
//            self.transition(2, controller: viewContainer)
//        }
//        else{
//            self.transition(3, controller: viewContainer)
//        }
        
        Global.sharedInstance.indexOfHomeSegment = selectedSegment
        self.tableView.reloadData()
      
    }
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.sharedInstance.indexOfHomeSegment == 0 {
            if(self.arrChatList.count == 0)
            {
              self.tableView.backgroundView = self.addNoData(message: "No Recents chats available.")
                
            }else{
                self.tableView.backgroundView = nil
            }
            return arrChatList.count
        }else{
            self.tableView.backgroundView = self.addNoData(message: "No Recents calls available.")
           return 0
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str = "ChatTableViewCell"
        if Global.sharedInstance.indexOfHomeSegment == 0 {
           str = "ChatTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatTableViewCell
           cell.setChatListData(chatList: arrChatList[indexPath.row])
            
            return cell
        }else{
           str = "ChatTableViewCell1"
           let cell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! ChatTableViewCell
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension ViewController{
    
    func getChatList(loader:Bool){
        chatListHandler.chatListHandler(loader:loader, completion: {
            arrChatList,success,_ in
             self.tableView.isHidden = false
            if success == true{
                self.arrChatList = arrChatList
                self.tableView.reloadData()
            }else{
                
            }
            
            
        })
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
}
