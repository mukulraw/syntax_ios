//
//  LoginViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 24/11/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var googleSignBtn : UIButton!
    var userr : GIDGoogleUser?
    var googlePID = String()
    var googleFullName = String()
    var googleEmailId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsProperty()
        if(FBSDKAccessToken.current() == nil){
            print("Not logged in ")
        } else {
            print("Logged in already")
           // getFacebookUserInfo()
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        if userr != nil{
            toggleAuthUI()
        }
    }
    //----------------Start Google Sign In-----------//
    // [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        // statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        //  statusText.text = "Disconnecting."
        // [END_EXCLUDE]
    }
    // [END disconnect_tapped]
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            // signInButton.isHidden = true
            //  signOutButton.isHidden = false
            //   disconnectButton.isHidden = false
            userr = GIDSignIn.sharedInstance().currentUser
            print("user = ",userr as Any)
            googlePID = (userr?.userID)!                  // For client-side use only!
            let idToken = userr?.authentication.idToken // Safe to send to the server
            googleFullName = (userr?.profile.name)!
            let givenName = userr?.profile.givenName
            let familyName = userr?.profile.familyName
            googleEmailId = (userr?.profile.email)!
            
            print("login userid = \(googlePID )")
            print("login idToken = \(idToken ?? "")")
            print("login fullName = \(googleFullName)")
            print("login givenName = \(givenName ?? "")")
            print("login familyName = \(familyName ?? "")")
            print("login email = \(googleEmailId)")
            
            self.FacebookLogin(fpid: googlePID, femail: googleEmailId)
            
        } else {
            googleSignBtn.isHidden = false
            //   signOutButton.isHidden = true
            //    disconnectButton.isHidden = true
            //    statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo["statusText"]!)
                //print("Email=",userInfo["email"]!)
                //   self.statusText.text = userInfo["statusText"]!
            }
        }
    }
    //--------------End Of Google Sign In----------------//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func showHidPassword(_ sender: UIButton){
        if(passwordTextField.isSecureTextEntry == true){
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func loginAction(_ sender: UIButton){
        guard self.emailTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter email id!", viewController: self)
            return
        }
        guard UtilityClass.sharedUtils.isValidEmail(testStr: self.emailTextField.text!) == true else {
            Alert.showBasic(title: "", message:"Please enter valid email id!", viewController: self)
            return
        }
        guard self.passwordTextField.text?.isEmpty == false else {
            Alert.showBasic(title: "", message:"Please enter password!", viewController: self)
            return
        }
        
        LoginApiCall()
    }
    @IBAction func forgotPasswordAction(_ sender: UIButton){
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    @IBAction func newUserSignUp(_ sender: UIButton){
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: TextFields Property Set Up
extension LoginViewController{
    func textFieldsProperty(){
        emailTextField.placeholder = "Enter Email Id"
        emailTextField.title = "Your Email Id"
        emailTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        emailTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.title = "Your Password"
        passwordTextField.titleColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        passwordTextField.selectedLineColor = UIColor(red: 54.0/255.0, green: 47.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    }
}

// MARK: Login Api Call
extension LoginViewController{
    func LoginApiCall(){
        var myResponse : JSON? = nil
        var loginResponse : LoginClass? = nil
        let parameter : [String:Any] = ["action": LoginAction,
                         "data":["email":self.emailTextField.text,"password":self.passwordTextField.text]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            loginResponse = LoginClass(loginJson: myResponse!)
            print("response = ",loginResponse?.status as Any)
            
            if loginResponse?.status == "1"{
                
                UserDefaults.standard.set(loginResponse?.dataClass?.userId, forKey: "USERID")
                UserDefaults.standard.set(loginResponse?.dataClass?.name, forKey: "USERNAME")
                UserDefaults.standard.set(loginResponse?.dataClass?.email, forKey: "EMAILID")
                UserDefaults.standard.set(loginResponse?.dataClass?.mobile, forKey: "PHONENUMBER")
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set(true, forKey: "NOTESVIEW")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.isNavigationBarHidden = true
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
            else{
                Alert.showBasic(title: "", message:(loginResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

// MARK: Facebook Login Button Action
extension LoginViewController{
    @IBAction func FacbookBtnAction(_ sender: Any) {
        getFacebookUserInfo()
    }
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions:[.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = FBSDKGraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info)
                    let name = info["name"] as! String
                    print(name)
                    let email = info["email"] as! String
                    print(email)
                    let pid = info["id"] as! String
                    print(pid)
                    self.FacebookLogin(fpid: pid, femail: email)
                }
                Connection.start()
            default:
                print("??")
            }
        }
    }
    
    // MARK: Same Function For Google And Facebook SignIn
    func FacebookLogin(fpid:String, femail:String){
        var myResponse : JSON? = nil
        var loginResponse : LoginClass? = nil
        let parameter : [String:Any] = ["action": SocialLogin_Action,
                                        "data":["email":femail,"pid":fpid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            loginResponse = LoginClass(loginJson: myResponse!)
            print("response = ",loginResponse?.status as Any)
            
            if loginResponse?.status == "1"{
                
                UserDefaults.standard.set(loginResponse?.dataClass?.userId, forKey: "USERID")
                UserDefaults.standard.set(loginResponse?.dataClass?.name, forKey: "USERNAME")
                UserDefaults.standard.set(loginResponse?.dataClass?.email, forKey: "EMAILID")
                UserDefaults.standard.set(loginResponse?.dataClass?.mobile, forKey: "PHONENUMBER")
                UserDefaults.standard.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.isNavigationBarHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                Alert.showBasic(title: "", message:(loginResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

// MARK: Google Login
extension LoginViewController{

    @IBAction func GoogleBtnAction(_ sender: Any){
        GIDSignIn.sharedInstance().signIn()
    }
    
}
