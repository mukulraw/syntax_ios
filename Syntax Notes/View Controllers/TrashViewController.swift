//
//  TrashViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 10/09/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class TrashViewController: UIViewController {

    @IBOutlet weak var trashCollectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    
    var selectedCells : NSMutableArray = []
    var noteIdArray : NSMutableArray = []
    var flag = Int()
    var objectData:[NSManagedObject]!  = nil
    var trashDataArray = [TrashListData](){
        didSet{
            trashCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xibRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flag = 1
        self.cancelBtn.isHidden = true
        self.selectBtn.isHidden = false
        self.trashCollectionView.allowsMultipleSelection = true
        getTrashNotesData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Restore Action
    @IBAction func restoreAction(_ sender: UIButton){
        if(selectedCells.count == 0){
            Alert.showBasic(title: "", message:"Please select note!", viewController: self)
        } else{
            print("note id array ", self.noteIdArray)
            let iDArrayString = self.noteIdArray.componentsJoined(by: ",")
            print("note id array string ", iDArrayString)
            restoreMultipleNote(noteIds:iDArrayString)
        }
    }
    
    // MARK: - Trash Action
    @IBAction func trashAction(){
        let alert =  UIAlertController(title: nil, message: "Empty Trash?", preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.deleteFromTrash()
        }
        let no = UIAlertAction(title: "No", style: UIAlertAction.Style.default){
            UIAlertAction in
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Select Note Action
    @IBAction func selectAcion(sender: UIButton){
        flag = 2
        self.selectBtn.isHidden = true
        self.cancelBtn.isHidden = false
        trashCollectionView.reloadData()
    }
    
    // MARK: Cancel Selected Note Action
    @IBAction func cancelAction(sender: UIButton){
        self.flag = 1
        self.selectedCells.removeAllObjects()
        self.noteIdArray.removeAllObjects()
        self.cancelBtn.isHidden = true
        self.selectBtn.isHidden = false
        self.trashCollectionView.reloadData()
    }
    
    @objc func tickBtnMethod(_ sender: UIButton) {
        if let index = Helper.getIndexPathFor(view: sender, collectionView: trashCollectionView) {
            if selectedCells.contains(index) {
                let indexA = selectedCells.index(of: index)
                selectedCells.removeObject(at: indexA)
            } else {
                selectedCells.add(index)
            }
            if noteIdArray.contains(trashDataArray[index.item].id) {
                let indexA = noteIdArray.index(of: trashDataArray[index.item].id)
                noteIdArray.removeObject(at: indexA)
            } else {
                noteIdArray.add(trashDataArray[index.item].id)
            }
            trashCollectionView.reloadItems(at: [index])
        }
    }
}
// MARK: CollectionView Delegates and DataSource
extension TrashViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trashDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        cell.titleLabel.text = trashDataArray[indexPath.row].title
        
        cell.noteLabel.text = trashDataArray[indexPath.row].desc
        cell.noteTV.text = trashDataArray[indexPath.row].desc
        cell.noteTV.isEditable = false
        cell.noteTV.dataDetectorTypes = .all
        cell.noteTV.isSelectable = true
        cell.noteTV.delegate = self
        
        cell.categroyNameLabel.text = trashDataArray[indexPath.row].catName
        cell.timeLabel.text = UtilityClass.sharedUtils.convertDateTimeString(dateTimeString: trashDataArray[indexPath.row].createDate)
        
        if selectedCells.contains(indexPath) {
            cell.isSelected=true
            trashCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
            cell.tickBtn.isHidden=false
            cell.tickBtn.isSelected = true
        } else {
            cell.isSelected=false
            if(flag == 1){
                cell.tickBtn.isHidden=true
                cell.tickBtn.isSelected = true
            } else {
                cell.tickBtn.isHidden = false
                cell.tickBtn.isSelected = false
            }
        }
        cell.tickBtn.addTarget(self, action: #selector(tickBtnMethod(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: (width/2)-5, height: height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(flag == 1){
            let trashDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TrashDetailsViewController") as! TrashDetailsViewController
            trashDetailVC.category = trashDataArray[indexPath.row].catName
            trashDetailVC.titleString = trashDataArray[indexPath.row].title
            trashDetailVC.bodyString = trashDataArray[indexPath.row].desc
            trashDetailVC.noteID = trashDataArray[indexPath.row].id
            self.navigationController?.pushViewController(trashDetailVC, animated: true)
        } else {
            selectedCells.add(indexPath)
            noteIdArray.add(trashDataArray[indexPath.item].id)
            trashCollectionView.reloadItems(at: [indexPath])
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(flag == 1){
        } else {
            selectedCells.remove(indexPath)
            noteIdArray.remove(trashDataArray[indexPath.item].id)
            trashCollectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: XIB Register on CollectionView
extension TrashViewController{
    func xibRegister(){
        self.trashCollectionView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
    }
}

// MARK: Get List Of Trashed Notes
extension TrashViewController{
    func getTrashNotesData(){
        
        var myResponse : JSON? = nil
        var trashResponse : TrashListClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": TrashListAction,"data":["userId":userid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            trashResponse = TrashListClass(trashListJson: myResponse!)
            if trashResponse?.status == "1"{
                self.trashDataArray = (trashResponse?.trashDataArray)!
            } else {
                Alert.showBasic(title: "", message:(trashResponse?.message)!, viewController: self)
            }
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

// MARK: Trash Empty
extension TrashViewController{
    func deleteFromTrash(){
        var myResponse : JSON? = nil
        var deleteTrashResponse : DeleteTrashClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action":DeleteTrashAction,"data":["userId":userid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            deleteTrashResponse = DeleteTrashClass(deleteTrashJson: myResponse!)
            
            if deleteTrashResponse?.status == "1"{
                self.getTrashNotesData()
                Alert.showBasic(title: "", message:"Trash is empty", viewController: self)
            } else {
                Alert.showBasic(title: "", message:(deleteTrashResponse?.message)!, viewController: self)
            }
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

// MARK: Move Multiple Note From Trash To Home
extension TrashViewController{
    func restoreMultipleNote(noteIds:String){
        var myResponse : JSON? = nil
        var recoverNoteResponse : RecoverClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action":RecoverMultipleAction,"data":["userId":userid,"noteId":noteIds]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            recoverNoteResponse = RecoverClass(recoverJson: myResponse!)
            
            if recoverNoteResponse?.status == "1"{
                self.flag = 1
                self.selectedCells.removeAllObjects()
                self.noteIdArray.removeAllObjects()
                self.trashCollectionView.reloadData()
                self.cancelBtn.isHidden = true
                self.selectBtn.isHidden = false
                self.getTrashNotesData()
                Alert.showBasic(title: "", message:(recoverNoteResponse?.message)!, viewController: self)
            } else {
                Alert.showBasic(title: "", message:(recoverNoteResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

extension TrashViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
