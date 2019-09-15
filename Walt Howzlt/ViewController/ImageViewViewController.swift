//
//  ImageViewViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 28/05/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class ImageViewViewController: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageOuter: UIImageView!
    @IBOutlet weak var scrollviewOter: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var titlestr = String()
    var imageview = [[String: Any]]()
    var arrMedia = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollviewOter.isHidden = true
        scrollviewOter.delegate = self
        
        btnClose.isHidden = true
        if imageview.count != 1{
            self.lblTitle.text = "\(self.imageview.count) images"
        }else{
            self.lblTitle.text = "image"
        }
        if arrMedia.count > 0 {
            self.lblTitle.text = "Media"
        }
        scrollviewOter.minimumZoomScale = 1.0
        scrollviewOter.maximumZoomScale = 10.0
       
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
        // txtMessage.isUserInteractionEnabled = false
    }
    func setImage(url:String) -> URL?{
        
        let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            return url
        }
        return nil
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.scrollviewOter.isHidden = true
        self.btnClose.isHidden = true
        collectionView.isHidden = false
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageOuter
    }
}
extension ImageViewViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        
        if arrMedia.count > 0 {
            let url = arrMedia[indexPath.item]
            cell.imageView.af_setImage(withURL: self.setImage(url: url as! String)!)
        }else{
            let url = imageview[indexPath.item]["file_url"] as! String
            cell.imageView.af_setImage(withURL: self.setImage(url: url)!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrMedia .count > 0 {
            return arrMedia.count
        }
        return imageview.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.scrollviewOter.isHidden == true{
            self.scrollviewOter.isHidden = false
            collectionView.isHidden = true
             btnClose.isHidden = false
            if arrMedia.count > 0 {
                let url = arrMedia[indexPath.item]
                imageOuter.af_setImage(withURL: self.setImage(url: url as! String)!)
            }else{
                let url = imageview[indexPath.item]["file_url"] as! String
                imageOuter.af_setImage(withURL: self.setImage(url: url)!)
            }
        }else{
            self.scrollviewOter.isHidden = true
        }
    }
    
    
    
}
