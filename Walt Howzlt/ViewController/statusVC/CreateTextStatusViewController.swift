//
//  CreateTextStatusViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CreateTextStatusViewController: UIViewController {
   
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var imageBg: UIImageView!    
    @IBOutlet weak var txtViewContainer: NextGrowingTextView!
    @IBOutlet weak var btnColorChange: UIButton!
    @IBOutlet weak var bottomConstaint: KeyboardLayoutConstraint!
    
    var selectedIndex = Int()
    var colorCode = ["#1ABC9C","#2ECC71","#3498DB","#9B59B6","#F1C40F","#E67E22","#2C3E50","#0984E3","#E84393","#FdCB6E","#6C5CE7","#B2BEC3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewContainer.textView.becomeFirstResponder()
        txtViewContainer.textView.textColor = .white
        txtViewContainer.maxNumberOfLines = 7
        bottomConstaint.constant = 20
        self.imageBg.backgroundColor = UIColor(hexString: colorCode[selectedIndex])
        //
        // txtView.centerVertically()
        btnSend.layer.cornerRadius = 25
        btnSend.clipsToBounds = true
        addToolBar()
        btnColorChange.backgroundColor = UIColor.white.withAlphaComponent(0.74)
        btnColorChange.layer.cornerRadius = 25
        btnColorChange.clipsToBounds = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillHide(notification: Notification) {
        
       self.bottomConstaint.constant = 20.0
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
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    
    @IBAction func btnBcak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        if txtViewContainer.textView.text != ""{
            self.sendStatus()
        }
    }
    func sendStatus(){
        StatusHandler.statusHandler.addCurrentStatus(status_type: "text", status_text: txtViewContainer.textView.text ?? "", status_text_color: self.colorCode[selectedIndex], image: nil, completion: {_,_,_ in
            DispatchQueue.main.async {
                 self.navigationController?.popViewController(animated: true)
            }
           
        })
        
    }
    func addToolBar(){
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtViewContainer.textView.inputAccessoryView = numberToolbar
    }
    

    
    @objc func cancelNumberPad() {
        //Cancel with number pad
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        //Done with number pad
        self.view.endEditing(true)
    }
    
    @IBAction func btnColorChaage(_ sender: Any) {
        
        selectedIndex  = selectedIndex + 1
        if selectedIndex > self.colorCode.count - 1 {
            selectedIndex = 0
        }
       self.imageBg.backgroundColor = UIColor(hexString: colorCode[selectedIndex].uppercased())
    }
    @IBAction func btnSmile(_ sender: Any) {
    }
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
