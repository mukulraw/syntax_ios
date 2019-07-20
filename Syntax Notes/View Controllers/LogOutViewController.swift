//
//  LogOutViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 16/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesAction(_ sender: UIButton){
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "NOTESVIEW")
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.synchronize()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.FirstOpen()
    }

    @IBAction func no_Back_Action(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
