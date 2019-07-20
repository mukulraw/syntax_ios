//
//  SignUpViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 08/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var retypePassTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetUp()
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showHidePassword(_ sender: UIButton){
        if(passwordTextField.isSecureTextEntry == true){
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func showHideRetypePass(_ sender: UIButton){
        if(retypePassTextField.isSecureTextEntry == true){
            retypePassTextField.isSecureTextEntry = false
        } else {
            retypePassTextField.isSecureTextEntry = true
        }
    }
    @IBAction func signUpAction(_ sender: UIButton){
        guard self.nameTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter name!", viewController: self)
            return
        }
        guard self.emailTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter email id!", viewController: self)
            return
        }
        guard UtilityClass.sharedUtils.isValidEmail(testStr: self.emailTextField.text!) == true else {
            Alert.showBasic(title: "", message:"Please enter valid email id!", viewController: self)
            return
        }
        guard self.mobileTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter mobile number!", viewController: self)
            return
        }
        guard self.passwordTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter password!", viewController: self)
            return
        }
        guard self.retypePassTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please retype the password!", viewController: self)
            return
        }
        guard self.retypePassTextField.text == passwordTextField.text else {
            Alert.showBasic(title: "", message:"Password are retype password are not same!", viewController: self)
            return
        }
        
        SignUpApiCall()
    }
    @IBAction func alreadyAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: TextFields Property Set Up
extension SignUpViewController{
    func textFieldsSetUp(){
        nameTextField.placeholder = "Enter Name"
        nameTextField.title = "Your Name"
        nameTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        nameTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        emailTextField.placeholder = "Enter Email Id"
        emailTextField.title = "Your Email"
        emailTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        emailTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        mobileTextField.placeholder = "Enter Mobile Number"
        mobileTextField.title = "Your Mobile Number"
        mobileTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        mobileTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.title = "Your Password"
        passwordTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        passwordTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        retypePassTextField.placeholder = "Retype Password"
        retypePassTextField.title = "Your Password"
        retypePassTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        retypePassTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    }
}

// MARK: SignUp API Call
extension SignUpViewController{
    func SignUpApiCall(){
        var myResponse : JSON? = nil
        var signupResponse : SignupClass? = nil
        
        let parameter:[String:Any] = ["action": RegisterAction,
                                      "data":["name":self.nameTextField.text,"phone":self.mobileTextField.text,"email":self.emailTextField.text,"password":self.passwordTextField.text]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            signupResponse = SignupClass(signupJson: myResponse!)
            print("response = ",signupResponse?.status as Any)
            
            if signupResponse?.status == "1"{
                Alert.showBasicToPop(title: "", message: "Signup is successful", viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(signupResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
