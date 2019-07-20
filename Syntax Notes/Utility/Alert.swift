//
//  Alert.swift
//  ETHRO BASKET
//
//  Created by apple on 8/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import SwiftMessages

class Alert {
    
    class func showBasic(title:String,message:String,viewController:UIViewController)  {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showBasicToPop(title:String,message:String,viewController:UIViewController)  {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okacn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ action in
            viewController.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okacn)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func AlertAction(fromVC:UIViewController,toVC:UIViewController) {
        let alert = UIAlertController(title: "Do you want to log out", message: "", preferredStyle: .alert)
        let okacn = UIAlertAction(title: "YES", style: UIAlertAction.Style.default){ action in
            fromVC.navigationController?.pushViewController(toVC, animated: true)
        }
        let cancelacn = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel ){ action in
        }
        alert.addAction(okacn)
        alert.addAction(cancelacn)
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    class func AlertActionToNilUserID(fromVC:UIViewController,toVC:UIViewController) {
        let alert = UIAlertController(title: "Do you want to log out", message: "", preferredStyle: .alert)
        let okacn = UIAlertAction(title: "YES", style: UIAlertAction.Style.default){ action in
            UserDefaults.standard.set(nil, forKey: "USERID")
            fromVC.navigationController?.pushViewController(toVC, animated: true)
        }
        let cancelacn = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel ){
            UIAlertAction in
        }
        alert.addAction(okacn)
        alert.addAction(cancelacn)
        fromVC.present(alert, animated: true, completion: nil)
    }
}

class POPMESSAGE {
    static let popmessage = POPMESSAGE()
    private init(){
    }
    func ErrorMessage(Title:String,Body:String){
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: Title, body: Body)
        error.button?.setTitle("Stop", for: .normal)
        error.button?.addTarget(self, action: #selector(tapaction), for: .touchUpInside)
        SwiftMessages.show(view: error)
    }
    
    func LongMessage() {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "Info", body: "This is a very lengthy and informative info message that wraps across multiple lines and grows in height as needed.")
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .seconds(seconds: 0.25)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func OtherMessage(){
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.purple
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "Switched to light status bar!")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: statusConfig, view: status)
    }
    
    func NoInternetMessage(){
        let status2 = MessageView.viewFromNib(layout: .statusLine)
        status2.backgroundView.backgroundColor = UIColor.red
        status2.bodyLabel?.textColor = UIColor.white
        status2.configureContent(body: "No Internet!")
        var status2Config = SwiftMessages.defaultConfig
        status2Config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        status2Config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: status2Config, view: status2)
    }
    
    @objc func tapaction() {
        print("Button clicked")
        SwiftMessages.hide()
    }
}
