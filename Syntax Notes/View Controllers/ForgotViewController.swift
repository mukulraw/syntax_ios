//
//  ForgotViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 08/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Enter Email Id"
        emailTextField.title = "Your Email"
        emailTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        emailTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    }

    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction(_ sender: UIButton){
        guard emailTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message: "Please enter email id!", viewController: self)
            return
        }
        guard UtilityClass.sharedUtils.isValidEmail(testStr: emailTextField.text!) == true else {
            Alert.showBasic(title: "", message: "Please enter valid email id!", viewController: self)
            return
        }
        
        ForgotApiCall()
    }
}
extension ForgotViewController{
    func ForgotApiCall(){
        var myResponse : JSON? = nil
        var forgotResponse : ForgotClass? = nil
        
        let parameter:[String:Any] = ["action": ForgotAction,
                                      "data":["email":self.emailTextField.text]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            forgotResponse = ForgotClass(forgotJson: myResponse!)
            print("response = ",forgotResponse?.status as Any)
            
            if forgotResponse?.status == "1"{
                self.emailTextField.text = ""
                Alert.showBasicToPop(title: "", message: (forgotResponse?.message)!, viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(forgotResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
