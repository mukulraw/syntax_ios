//
//  AddNotesViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 09/09/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import SwiftyJSON

class AddNotesViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var catButtnOutlet: UIButton!
    var categoryArray = [String]()
    var categoryIdArray = [String]()
    var categoryId = String()
    var dropDown = DropDown()
    var catBool = Bool()
    
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
    
    // MARK: - Done Action
    @IBAction func doneAction(_ sender: UIButton!){
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
        
        createNote()
    }
    
    // MARK: - Back Actionn
    @IBAction func backAction(){
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - TextView Delegate Mathods
extension AddNotesViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
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
extension AddNotesViewController{
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
    
    // MARK: Create Note
    func createNote(){
        var myResponse : JSON? = nil
        var createNoteResponse : CreateNoteClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": CreateNoteAction,"data":["userId":userid,"title":self.titleTextView.text!,"desc":self.noteTextView.text!,"catId":self.categoryId]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            createNoteResponse = CreateNoteClass(createNoteJson: myResponse!)
            print("response = ",createNoteResponse?.status as Any)
            
            if createNoteResponse?.status == "1"{
                Alert.showBasicToPop(title: "", message:(createNoteResponse?.message)!, viewController: self)
            }
            else{
                Alert.showBasic(title: "", message:(createNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}
