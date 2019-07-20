//
//  ChangePasswordViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 25/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetUp()
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showHidePassword(_ sender: UIButton){
        if(newPassTextField.isSecureTextEntry == true){
            newPassTextField.isSecureTextEntry = false
        } else {
            newPassTextField.isSecureTextEntry = true
        }
    }
    @IBAction func showHideRetypePass(_ sender: UIButton){
        if(confirmPassTextField.isSecureTextEntry == true){
            confirmPassTextField.isSecureTextEntry = false
        } else {
            confirmPassTextField.isSecureTextEntry = true
        }
    }
    @IBAction func updateBtnAction(_ sender: UIButton){
        guard self.oldPassTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter old password!", viewController: self)
            return
        }
        guard self.newPassTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter new password!", viewController: self)
            return
        }
        guard self.confirmPassTextField.text == newPassTextField.text else {
            Alert.showBasic(title: "", message:"New password and confirm password are not same!", viewController: self)
            return
        }
        changePasswordFunc()
    }
}
// MARK: TextFields Property Set Up
extension ChangePasswordViewController{
    func textFieldsSetUp(){
        
        oldPassTextField.placeholder = "Enter Old Password"
        oldPassTextField.title = "Your Old Password"
        oldPassTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        oldPassTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        newPassTextField.placeholder = "Enter New Password"
        newPassTextField.title = "Your New Password"
        newPassTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        newPassTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        confirmPassTextField.placeholder = "Confirm New Password"
        confirmPassTextField.title = "Your New Password"
        confirmPassTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        confirmPassTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    }
}

// MARK: Change Password Api Hit
extension ChangePasswordViewController{
    func changePasswordFunc(){
        var myResponse : JSON? = nil
        var changePassResponse : ChangePasswordClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        
        let parameters : [String:Any] = ["action":ChangePasswordAction, "data":["userId":userid, "password":self.newPassTextField.text]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameters, ViewController: self, loaderchek: 1, onCompletion:{ (commonJson) -> Void in
            
            myResponse = commonJson
            print("Response = ",myResponse as Any)
            changePassResponse = ChangePasswordClass(ChangePasswordJson: myResponse!)
            print("Response = ",changePassResponse?.status as Any)
            if(changePassResponse?.status == "1"){
                Alert.showBasicToPop(title: "", message: "Password updated successfully", viewController: self)
            }
            else{
                Alert.showBasic(title: "", message: changePassResponse?.message ?? "", viewController: self)
            }
            
        }) {
            (failure) -> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
