//
//  ViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 03/09/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var noteCollectinView: UICollectionView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var gridBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var deleteViewConstraint: NSLayoutConstraint!
    
    var noteDataArray = [AllNoteList]()
    var noteIdArray : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xibRegister()
        notesTableView.tableFooterView = UIView(frame: CGRect.zero)
        gridBtn.isHidden = true
        deleteViewConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let listViewStatus = UserDefaults.standard.value(forKey: "NOTESVIEW") as? Bool,
            listViewStatus == true {
            self.noteCollectinView.isHidden = false
            self.notesTableView.isHidden = true
        } else {
            self.noteCollectinView.isHidden = true
            self.notesTableView.isHidden = false
        }
        self.deleteView.isHidden = true
        self.noteCollectinView.allowsMultipleSelection = true
        getNotesData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Search Action
    @IBAction func searchAction(){
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: - Move To Note Create Page
    @IBAction func addNoteAction(_ sender: UIButton){
        let addNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    @objc func tickBtnMethod(_ sender: UIButton) {
        if let index = Helper.getIndexPathFor(view: sender, collectionView: noteCollectinView) {
            if noteIdArray.contains(noteDataArray[index.item].id) {
                let indexA = noteIdArray.index(of: noteDataArray[index.item].id)
                noteIdArray.removeObject(at: indexA)
            } else {
                noteIdArray.add(noteDataArray[index.item].id)
            }
            if noteIdArray.count > 0 {
                deleteViewConstraint.constant = 80
                self.deleteView.isHidden = false
            } else {
                deleteViewConstraint.constant = 0
                self.deleteView.isHidden = true
            }
            noteCollectinView.reloadItems(at: [index])
        }
    }
    
    @objc func tickBtnMethodForTable(_ sender: UIButton) {
        if let index = Helper.getIndexPathFor(view: sender, tableView: notesTableView) {
            if noteIdArray.contains(noteDataArray[index.section].id) {
                let indexA = noteIdArray.index(of: noteDataArray[index.section].id)
                noteIdArray.removeObject(at: indexA)
            } else {
                noteIdArray.add(noteDataArray[index.section].id)
            }
            if noteIdArray.count > 0 {
                deleteViewConstraint.constant = 80
                self.deleteView.isHidden = false
            } else {
                deleteViewConstraint.constant = 0
                self.deleteView.isHidden = true
            }
            notesTableView.reloadRows(at: [index], with: .automatic)
        }
    }
}

// MARK: XIB Register on CollectionView
extension ViewController{
    func xibRegister(){
        self.noteCollectinView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
    }
}

// MARK: Get List Of Notes
extension ViewController {
    func getNotesData() {
        var myResponse : JSON? = nil
        var notesResponse : AllNotesClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": AllNotesAction,"data":["userId":userid]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            notesResponse = AllNotesClass(allNoteJson: myResponse!)
            print("response = ",notesResponse?.status as Any)
            
            if notesResponse?.status == "1"{
                self.noteDataArray.removeAll()
                for i in 0..<notesResponse!.dataArray.count{
                    for j in 0..<notesResponse!.dataArray[i].noteListArray.count{
                        self.noteDataArray.append(notesResponse!.dataArray[i].noteListArray[j])
                    }
                }
                self.deleteViewConstraint.constant = 0
                self.noteCollectinView.reloadData()
                self.notesTableView.reloadData()
            } else {
                Alert.showBasic(title: "", message:(notesResponse?.message)!, viewController: self)
            }
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
    
    // MARK: Delete Multiple Notes To Trash
    func deleteMultiNotesToTrash(noteIds:String){
        var myResponse : JSON? = nil
        var deleteNoteResponse : DeleteNoteClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] =  ["action":DeleteMultipleAction,"data":["userId":userid,"noteId":noteIds]]
        
        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            deleteNoteResponse = DeleteNoteClass(deleteJson: myResponse!)
            print("response = ",deleteNoteResponse?.status as Any)
            
            if deleteNoteResponse?.status == "1"{
                self.noteIdArray.removeAllObjects()
                self.deleteView.isHidden = true
                self.noteCollectinView.reloadData()
                self.gridBtn.isHidden = true
                self.listBtn.isHidden = false
                self.getNotesData()
                Alert.showBasic(title: "", message:"Moved To Trash", viewController: self)
            } else {
                Alert.showBasic(title: "", message:(deleteNoteResponse?.message)!, viewController: self)
            }
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

extension ViewController{
    @IBAction func listAcion(sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "NOTESVIEW")
        self.listBtn.isHidden = true
        self.gridBtn.isHidden = false
        noteCollectinView.reloadData()
        noteCollectinView.isHidden = true
        notesTableView.isHidden = false
    }
    
    @IBAction func gridAction(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "NOTESVIEW")
        self.noteIdArray.removeAllObjects()
        self.deleteView.isHidden = true
        self.gridBtn.isHidden = true
        self.listBtn.isHidden = false
        self.noteCollectinView.reloadData()
        
        noteCollectinView.isHidden = false
        notesTableView.isHidden = true
    }
    
    @IBAction func deleteAction(sender: UIButton){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         let alertAction1 = UIAlertAction(title: "Move to trash?", style: .default, handler:{ action in
                let iDArrayString = self.noteIdArray.componentsJoined(by: ",")
                self.deleteMultiNotesToTrash(noteIds: iDArrayString)
         })
         let alertAction2 = UIAlertAction(title: "Cancel", style: .default, handler: { action in
         })
         alertController.addAction(alertAction1)
         alertController.addAction(alertAction2)
         self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: UIButton){
        self.deleteView.isHidden = true
        self.deleteViewConstraint.constant = 0
    }
}

extension ViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {        
        return true
    }
}

// MARK: CollectionView Delegates and DataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        cell.categroyNameLabel.text = noteDataArray[indexPath.item].catName
        cell.titleLabel.text = noteDataArray[indexPath.row].title
        
        cell.noteLabel.text = noteDataArray[indexPath.row].desc
        cell.noteTV.text = noteDataArray[indexPath.row].desc
        cell.noteTV.isEditable = false
        cell.noteTV.dataDetectorTypes = .all
        cell.noteTV.isSelectable = true
        cell.noteTV.delegate = self
        
        cell.timeLabel.text = UtilityClass.sharedUtils.convertDateTimeString(dateTimeString: noteDataArray[indexPath.row].createDate)
        
        if noteIdArray.contains(noteDataArray[indexPath.item].id) {
            cell.tickBtn.isSelected = true
            noteCollectinView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        } else {
            cell.tickBtn.isSelected = false
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
        let updateNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
        updateNoteVC.noteID = noteDataArray[indexPath.item].id
        updateNoteVC.categoryId = noteDataArray[indexPath.item].catId
        self.navigationController?.pushViewController(updateNoteVC, animated: true)
    }
}

// MARK: - Table view datasource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return noteDataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: view.frame.width, height: 40))
        label.textColor = UIColor.darkGray
        label.text = noteDataArray[section].catName
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = noteDataArray[indexPath.section].title
        cell.dateLabel.text = noteDataArray[indexPath.section].createDate
        cell.tickBtn.addTarget(self, action: #selector(tickBtnMethodForTable(_:)), for: .touchUpInside)
        
        if noteIdArray.contains(noteDataArray[indexPath.section].id) {
            cell.tickBtn.isSelected = true
        } else {
            cell.tickBtn.isSelected = false
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
        updateNoteVC.noteID = noteDataArray[indexPath.row].id
        updateNoteVC.categoryId = noteDataArray[indexPath.row].catId
        self.navigationController?.pushViewController(updateNoteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
