//
//  EditStatusViewController.swift
//  Walt Howzlt
//
//  Created by Kavita on 06/09/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class EditStatusViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    var details = [OtherStatus]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
    }
    func deleteStatus(index:Int){
        StatusHandler.statusHandler.deleteSatus(statusID: self.details[index].current_status_id, completion: {_,_,_ in
            DispatchQueue.main.async {
                self.details.remove(at: index)
                self.tblView.reloadData()
            }
        })
    }
    @IBAction func btnBcak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EditStatusViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditStatusTableViewCell", for: indexPath)as! EditStatusTableViewCell
        cell.setData(status : self.details[indexPath.row])
        cell.callbackDelete = {
            self.deleteStatus(index:indexPath.row)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
