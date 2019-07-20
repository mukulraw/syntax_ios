//
//  SearchViewController.swift
//  Syntax Notes
//
//  Created by Sunny on 15/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchDataArray = [SearchData](){
        didSet{
            searchCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        xibRegister()
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: CollectionView Delegates and DataSource
extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionCell
        cell.titleLabel.text = searchDataArray[indexPath.row].title
        cell.noteLabel.text = searchDataArray[indexPath.row].description
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: (width/2)-5, height: height/3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let updateNoteVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
        updateNoteVC.noteID = searchDataArray[indexPath.item].id
        updateNoteVC.categoryId = searchDataArray[indexPath.item].catId
        self.navigationController?.pushViewController(updateNoteVC, animated: true)
    }
}

// MARK: XIB Register on CollectionView
extension SearchViewController{
    func xibRegister(){
        self.searchCollectionView.register(UINib(nibName: "SearchCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionCell")
    }
}

// MARK: Get List Of Searched Notes
extension SearchViewController{
    func getNotesData(searchtext:String){
        
        var myResponse : JSON? = nil
        var searchResponse : SearchClass? = nil
        let userid = UserDefaults.standard.string(forKey: "USERID")
        let parameter:[String:Any] = ["action": SearchNoteAction,"data":["userId":userid,"key":searchtext]]

        APIManager.shared.getResponseFromPost(ParaMeters: parameter, ViewController: self, loaderchek: 1, onCompletion:{ (commonjson) -> Void in
            
            myResponse = commonjson
            print("response = ",myResponse as Any)
            searchResponse = SearchClass(searchListJson: myResponse!)
            print("response = ",searchResponse?.status as Any)
            
            if searchResponse?.status == "1"{
                self.searchDataArray = (searchResponse?.searchDataArray)!
            }
            else{
                Alert.showBasic(title: "", message:(searchResponse?.message)!, viewController: self)
            }
            
        })
        {
            (failure)-> Void in
            POPMESSAGE.popmessage.NoInternetMessage()
        }
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getNotesData(searchtext: searchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.getNotesData(searchtext: self.searchBar.text!)
    }
}
