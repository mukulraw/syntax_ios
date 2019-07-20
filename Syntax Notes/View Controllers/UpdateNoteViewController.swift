//
//  UpdateNoteViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 15/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class UpdateNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var catButtnOutlet: UIButton!
    var categoryArray = [String]()
    var categoryIdArray = [String]()
    var categoryId = String()
    var dropDown = DropDown()
    var catBool = Bool()
    lazy var noteID: String = {
        let noteID = String()
        return noteID
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.text = "Enter Title"
        titleTextView.textColor = UIColor.lightGray
        noteTextView.text = "Enter Note"
        noteTextView.textColor = UIColor.lightGray
        
        noteTextView.dataDetectorTypes = .all
        titleTextView.dataDetectorTypes = .all
        
        getCategoryData()
        
        catBool = false
        dropDown.anchorView = catButtnOutlet
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.catBool = true
            self.categoryId = self.categoryIdArray[index]
            self.catButtnOutlet.setTitleColor(UIColor.black, for: .normal)
            self.catButtnOutlet.setTitle(self.categoryArray[index], for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func catButtonAction(_ sender:UIButton){
        self.dropDown.show()
    }
    
    // MARK: - Share Action
    @IBAction func shareAction(_ sender: UIButton){
        let referalStr = [titleTextView.text, noteTextView.text] as! [String]
        let activityVC = UIActivityViewController.init(activityItems: referalStr, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - Move To Trash Action
    @IBAction func deleteAction(_ sender: UIButton){
        
            let alert =  UIAlertController(title: nil, message: "Move To Trash?", preferredStyle: UIAlertController.Style.alert)
            let yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default){
                UIAlertAction in
                self.deleteNoteToTrash()
            }
            let no = UIAlertAction(title: "No", style: UIAlertAction.Style.default){
                UIAlertAction in
                
            }
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Done Action
    @IBAction func updateAction(_ sender: UIButton!){
        guard catBool == true else {
            Alert.showBasic(title: "", message: "Please select category!", viewController: self)
            return
        }
        guard (titleTextView.text != "Enter Title" || titleTextView.text.isEmpty == true) else{
            Alert.showBasic(title: "", message: "Please enter title!", viewController: self)
            return
        }
        guard (noteTextView.text != "Enter Note" || noteTextView.text.isEmpty == true) else{
            Alert.showBasic(title: "", message: "Please enter note!", viewController: self)
            return
        }
        
        updateNote()
    }
    
    // MARK: - Back Actionn
    @IBAction func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TextView Delegate Mathods
extension UpdateNoteViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            //textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty){
            textView.textColor = UIColor.lightGray
            
            if(textView == titleTextView){
                textView.text = "Enter Title"
            }
            else{
                textView.text = "Enter Note"
            }
        }
    }
}

// MARK: Get List Of Categories And Create Notes
extension UpdateNoteViewController{
    
    // MARK: Get List Of Categories
    func getCategoryData(){
        var myResponse : JSON? = nil
        var categoryResponse : CategoryListClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": CategoryListAction,"data":["userId":userid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            categoryResponse = CategoryListClass(categoryListJson: myResponse!)
            print("response = ",categoryResponse?.status as Any)
            
            if categoryResponse?.status == "1"{
                for i in 0..<categoryResponse!.categoryDataArray.count{
                    let singleCategory = categoryResponse!.categoryDataArray[i].catName
                    let singleCatId = categoryResponse!.categoryDataArray[i].id
                    self.categoryArray.append(singleCategory)
                    self.categoryIdArray.append(singleCatId)
                }
                self.dropDown.dataSource = self.categoryArray
                self.detailOfNote()
            }
            else{
                Alert.showBasic(title: "", message:(categoryResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
    
    // MARK: Update Note
    func updateNote(){
        var myResponse : JSON? = nil
        var updateNoteResponse : EditNoteClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": EditNoteAction,"data":["userId":userid,"noteId":self.noteID,"title":self.titleTextView.text!,"description":self.noteTextView.text!,"catId":self.categoryId]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            updateNoteResponse = EditNoteClass(editJson: myResponse!)
            print("response = ",updateNoteResponse?.status as Any)
            
            if updateNoteResponse?.status == "1"{
                Alert.showBasicToPop(title: "", message:(updateNoteResponse?.message)!, viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(updateNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
    
    // MARK: Detail Of Single Note
    func detailOfNote(){
        var myResponse : JSON? = nil
        var detailNoteResponse : SingleNoteDetailClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action":SingleNoteDetails,"data":["userId":userid,"noteId":self.noteID]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            detailNoteResponse = SingleNoteDetailClass(singleNoteJson: myResponse!)
            print("response = ",detailNoteResponse?.status as Any)
            
            if detailNoteResponse?.status == "1"{
                self.titleTextView.text = detailNoteResponse?.singleNotedata?.title
                self.titleTextView.textColor = UIColor.black
                self.noteTextView.text = detailNoteResponse?.singleNotedata?.description
                self.noteTextView.textColor = UIColor.black
                
                self.noteTextView.dataDetectorTypes = .all
                let indexx = self.categoryIdArray.firstIndex(of: (detailNoteResponse?.singleNotedata?.catId)!)!
                self.catButtnOutlet.setTitle(self.categoryArray[indexx], for: .normal)
                self.catButtnOutlet.setTitleColor(UIColor.black, for: .normal)
                self.catBool = true
            }
            else{
                Alert.showBasic(title: "", message:(detailNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
    
    // MARK: Delete Note To Trash
    func deleteNoteToTrash(){
        var myResponse : JSON? = nil
        var deleteNoteResponse : DeleteNoteClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action":DeleteNoteAction,"data":["userId":userid,"noteId":self.noteID]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            deleteNoteResponse = DeleteNoteClass(deleteJson: myResponse!)
            print("response = ",deleteNoteResponse?.status as Any)
            
            if deleteNoteResponse?.status == "1"{
                Alert.showBasicToPop(title: "", message:"Note Moved To Trash", viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(deleteNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
