//
//  AddGroupViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 18/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import OpalImagePicker
class AddGroupViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    var arrContacts = [ContactModel]()
    @IBOutlet weak var lblPartciapts: UILabel!
    
    @IBOutlet weak var txtGropuName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgGroup: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPartciapts.text =
        "Participats: \(arrContacts.count)"
        imagePicker.delegate = self
         self.imgGroup.layer.cornerRadius = self.imgGroup.frame.size.width / 2
        self.imgGroup.contentMode = .scaleAspectFill
        self.imgGroup.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        btnNext.layer.cornerRadius = btnNext.frame.size.width / 2
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChnageImage(_ sender: Any) {
        openGallery()
    }
    func openGallery()
    {
       
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
            self.imgGroup.image  = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNext_Action(_ sender: Any) {
        if txtGropuName.text?.count == 0{
            showAlertFor(alertTitle: "", alertMessage: "Please enter group Name")
        }else{
            var str = [Global.sharedInstance.UserID]
            for item in arrContacts{
                str.append(item.other_user_id)
            }
            print(str)
            GroupChatHandler.shared.createGroup(groupName: txtGropuName.text!, groupmember:str, selectedImage: self.imgGroup.image ?? UIImage(), completion: {_,_ in
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                print("success")
            })
        }
    }
}

extension AddGroupViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrContacts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupMemberCollectionViewCell", for: indexPath) as! GroupMemberCollectionViewCell
        cell.configureCell(contact: arrContacts[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 3 , height: self.view.frame.size.width / 4)
    }
}
