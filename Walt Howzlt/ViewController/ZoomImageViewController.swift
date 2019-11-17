//
//  ZoomImageViewController.swift
//  Walt Howzlt
//
//  Created by My on 13/11/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var scrlView: UIScrollView!
     @IBOutlet  var imgView_Zoom: UIImageView!
    var imgView: UIImage!
    var imgCount = Int()
    var arrImages = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrlView.minimumZoomScale = 1.0
               scrlView.maximumZoomScale = 10.0
       imgView_Zoom.image = imgView
        // Do any additional setup after loading the view.
        //self.loadImages()
    }
    
    func loadImages() {
        var offset: CGFloat = 0
        let scrollViewWidth = self.view.frame.size.width
        let scrollViewHeight = self.view.frame.size.height
        for imgUrl in arrImages {
            let imgView = UIImageView(frame: CGRect(x:offset, y:0.0 ,width:scrollViewWidth, height:scrollViewHeight))
            
             imgView.af_setImage(withURL: self.setImage(url: imgUrl as! String)!)

            imgView.contentMode = .scaleAspectFit
            self.scrlView.addSubview(imgView)

            offset += scrollViewWidth + 10
            self.scrlView.contentSize = CGSize(width: offset, height: scrollViewHeight)
            self.scrlView.isScrollEnabled = true
            
            }
        print("self.scrlView.contentSize = \(self.scrlView.contentSize)")
        }
        
    func setImage(url:String) -> URL?{
           let myURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
           if let url = URL(string: myURL!) {
               return url
           }
           return nil
           
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnClose(_ sender: Any) {
      self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        //let page = scrlView.contentOffset.x / scrlView.frame.size.width;
        
      //   imgView_Zoom.af_setImage(withURL: self.setImage(url: arrImages[Int(page)] as! String)!)
        return imgView_Zoom
    }
}
