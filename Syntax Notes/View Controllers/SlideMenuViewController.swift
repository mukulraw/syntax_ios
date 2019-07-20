//
//  SlideMenuViewController.swift
//  ETHRO BASKET
//
//  Created by apple on 8/3/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    let itemArray = ["Home", "Add Notes", "Trash", "Profile", "Log Out"]
    let iconArray = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "note"),#imageLiteral(resourceName: "trash"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SlideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        let itemLabel = cell?.contentView .viewWithTag(101) as! UILabel
        itemLabel.text = itemArray[indexPath.row]
        let iconImageview = cell?.contentView.viewWithTag(100) as! UIImageView
        iconImageview.image = iconArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let addNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
            self.navigationController?.pushViewController(addNoteVC, animated: true)
        case 2:
            let trashVC = self.storyboard?.instantiateViewController(withIdentifier: "TrashViewController") as! TrashViewController
            self.navigationController?.pushViewController(trashVC, animated: true)
        case 3:
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        default:
            let logOutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
            self.navigationController?.pushViewController(logOutVC, animated: true)
        }
    }
}
