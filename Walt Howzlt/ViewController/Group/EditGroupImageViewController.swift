//
//  EditGroupImageViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 27/07/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import OpalImagePicker
class EditGroupImageViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate{
    @IBOutlet weak var imageView: UIImageView!
    var groupImage = String()
    var groupId = String()
    var selectedImage = UIImage()
    var imagePicker = UIImagePickerController()
    var isComeFrom = false
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnEdit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupId.isEmpty {
            btnEdit.isHidden = true
        }
        
        imagePicker.delegate = self
        let myURL = groupImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if isComeFrom == false {
            if let url = URL(string: myURL!) {
                self.imageView.af_setImage(withURL: url)
            }
            else{
                self.imageView.image = #imageLiteral(resourceName: "uploadUser")
            }
        }
       
       // imageView.isUserInteractionEnabled = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEdit(_ sender: Any) {

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
            self.imageView.image  = pickedImage
            self.selectedImage = pickedImage
            self.updateImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func updateImage(){
        GroupInfoHandler.shared.uplaodImage(image: [selectedImage], group_id: self.groupId, completion: {_,_,json in
             print(json)
            
        })
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
