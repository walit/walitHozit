//
//  ProfileViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 22/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ProfileViewController:  UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    var selectedImage = UIImage()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imgMan: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStaus: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        getProfileData()
        btnEdit.layer.cornerRadius = 25
        btnEdit.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    func getProfileData(){
        ProfileHandler.shared.getuserInfo(userid:Global.sharedInstance.UserID,completion: {succes,json,error in
            print(json)
            DispatchQueue.main.async {
                if let dict = json["data"] as? [String:Any] {
                    self.lblName.text  = dict["username"] as? String ?? ""
                    self.lblStaus.text  = dict["status"] as? String ?? ""
                    self.lblMobileNumber.text = dict["phone"] as? String ?? ""
                    let strImage = dict["avatar"] as? String ?? ""
                    print(strImage)
                    let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    if let url = URL(string: myURL!) {
                        self.imgMan.af_setImage(withURL: url)
                    }
                    else{
                        self.imgMan.image = #imageLiteral(resourceName: "uploadUser")
                    }
                    self.imgMan.layer.cornerRadius = self.imgMan.frame.size.width / 2
                    self.imgMan.clipsToBounds = true
                }
                
            }
        })
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnEdit(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        vc.status = self.lblStaus.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func changeProfileImage(){
        //http://walit.net/api/howzit/v1/ProfileImageChange
        GroupInfoHandler.shared.uplaodUserImage(image: [self.selectedImage], completion: {_,_,_ in
            self.showAlertFor(alertTitle: "", alertMessage: "Image change successfully..")
        })
    }
    @IBAction func btnChangeProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            self.imgMan.image  = pickedImage
            self.selectedImage = pickedImage
            self.changeProfileImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }
   
}
