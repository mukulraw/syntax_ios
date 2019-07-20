//
//  ProfileViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 25/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetUp()
        viewProfileFunc()
    }
    @IBAction func ChangePassBtnAction(sender:UIButton){
        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    @IBAction func LogOutBtnAction(sender:UIButton){
        let logOutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        self.navigationController?.pushViewController(logOutVC, animated: true)
    }
}

// MARK: TextFields Property Set Up
extension ProfileViewController{
    func textFieldsSetUp(){
        nameTextField.placeholder = "Name"
        nameTextField.title = "Your Name"
        nameTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        nameTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        nameTextField.isUserInteractionEnabled = false
        
        emailTextField.placeholder = "Email Id"
        emailTextField.title = "Your Email"
        emailTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        emailTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        emailTextField.isUserInteractionEnabled = false
        
        mobileTextField.placeholder = "Mobile Number"
        mobileTextField.title = "Your Mobile Number"
        mobileTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        mobileTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        mobileTextField.isUserInteractionEnabled = false
        
    }
}

// MARK: View Profile Api Hit
extension ProfileViewController{
    func viewProfileFunc(){
        var myResponse : JSON? = nil
        var profileResponse : ViewProfileClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")

        let parameters : [String:Any] = ["action":GetProfileAction, "data":["userId":userid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameters, ViewController: self, loaderchek: 1, onCompletion:{ (commonJson) -> Void in
            
            myResponse = commonJson
            print("Response = ",myResponse as Any)
            profileResponse = ViewProfileClass(viewProfileJson: myResponse!)
            print("Response = ",profileResponse?.status as Any)
            if(profileResponse?.status == "1"){
                self.nameTextField.text = profileResponse?.profileData?.name
                self.emailTextField.text = profileResponse?.profileData?.email
                self.mobileTextField.text = profileResponse?.profileData?.mobile
            }
            else{
                Alert.showBasic(title: "", message: profileResponse?.message ?? "", viewController: self)
            }
            
        })
        {
            (failure) -> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
