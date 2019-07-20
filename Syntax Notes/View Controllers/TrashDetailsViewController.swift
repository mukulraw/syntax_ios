//
//  TrashDetailsViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 22/09/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class TrashDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    lazy var titleString: String = {
        let titleString = String()
        return titleString
    }()
    lazy var bodyString: String = {
        let bodyString = String()
        return bodyString
    }()
    lazy var noteID: String = {
        let noteID = String()
        return noteID
    }()
    lazy var category: String = {
        let category = String()
        return category
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.text = titleString
        bodyTextView.text = bodyString
        categoryLabel.text = category
        bodyTextView.dataDetectorTypes = .all
        titleTextView.dataDetectorTypes = .all
        bodyTextView.isEditable = false
        bodyTextView.isSelectable = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Restore Action
    @IBAction func restoreAction(_ sender: UIButton){
        restoreNote()
    }
    
    // MARK: - Share Action
    @IBAction func shareAction(_ sender: UIButton){
        let referalStr = String(format: "%@\n%@", titleString, bodyString)
        let activityVC = UIActivityViewController.init(activityItems: [referalStr], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - Back Action
    @IBAction func backAction(){
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: Move Note From Trash To Home
extension TrashDetailsViewController{
    func restoreNote(){
        var myResponse : JSON? = nil
        var recoverNoteResponse : RecoverClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action":RecoverNoteAction,"data":["userId":userid,"noteId":self.noteID]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            recoverNoteResponse = RecoverClass(recoverJson: myResponse!)
            print("response = ",recoverNoteResponse?.status as Any)
            
            if recoverNoteResponse?.status == "1"{
                Alert.showBasicToPop(title: "", message:(recoverNoteResponse?.message)!, viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(recoverNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
