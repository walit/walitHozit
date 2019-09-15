//
//  CreateImageStatusViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CreateImageStatusViewController: UIViewController {
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var imaageView: UIImageView!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imaageView.image = image
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnSend.layer.cornerRadius = 25
        btnSend.clipsToBounds = true
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    @objc func keyboardWillHide(notification: Notification) {
        
        self.bottomConstaint.constant = 30.0
    }
    @objc func keyboardWillShow(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                let keyboardVisibleHeight = frame.size.height
                self.bottomConstaint.constant =  5 + keyboardVisibleHeight
            }
        }
    }
    @IBAction func btnSend(_ sender: Any) {
        StatusHandler.statusHandler.addCurrentStatus(status_type: "image", status_text: txtMessage.text ?? "", status_text_color: "", image: image, completion: {_,_,_ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
           
        })
    }
    @IBAction func btnBcak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
