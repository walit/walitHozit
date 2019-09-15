//
//  StatusViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    @IBOutlet weak var imageText: UILabel!
    @IBOutlet weak var lblTextMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imagebg: UIImageView!
    var details = [OtherStatus]()
    var currentIndex = 0
    var spb : SegmentedProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatus(index: 0)
        spb = SegmentedProgressBar(numberOfSegments: self.details.count, duration: 8)
        spb.frame = CGRect(x: 15, y: 100, width: view.frame.width - 30, height: 4)
          spb.delegate = self
        spb.topColor = UIColor.white
        view.addSubview(spb)
        
        spb.startAnimation()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    
    
    
    func setStatus(index:Int){
        
        let status = self.details[index]
        lblTime.text = status.created_at
        
        if status.status_type == "text"{
            imageText.text = ""
           imagebg.layer.backgroundColor = UIColor(hexString: status.status_text_color)?.cgColor
            imagebg.image = nil
            lblTextMessage.text = status.status_text
        }else{
             imageText.text = status.status_text
             lblTextMessage.text = ""
            let strImage = status.status_images
            print(strImage)
            let myURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imagebg.af_setImage(withURL: url)
            }
            else{
                self.imagebg.image = #imageLiteral(resourceName: "uploadUser")
            }
            imagebg.contentMode = .scaleAspectFit
              imagebg.layer.backgroundColor = UIColor.black.cgColor
        }
    }
    @IBAction func btnBcak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPrivious(_ sender: Any) {
        if currentIndex != 0 {
            self.spb.rewind()
        }
       
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if !((currentIndex + 1) > details.count - 1 ) {
            self.spb.skip()
        }
        
    }
}
extension StatusViewController:SegmentedProgressBarDelegate{
  // has to conform to
    
    func segmentedProgressBarChangedIndex(index: Int) {
        self.setStatus(index: index)
        currentIndex = index
    }
    
    func segmentedProgressBarFinished() {
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spb.isPaused = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spb.isPaused = false
    }

}
