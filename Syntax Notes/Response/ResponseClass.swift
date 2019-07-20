//
//  ResponseClass.swift
//  Syntax Notes
//
//  Created by Sunny on 09/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation
import SwiftyJSON

// Login Response
class LoginClass {
    var message = String()
    var status = String()
    var dataClass:LoginData? = nil
    
    init(loginJson:JSON) {
        self.message = loginJson["message"].stringValue
        self.status = loginJson["status"].stringValue
        self.dataClass = LoginData(loginDataJson: loginJson["data"])
    }
}

class LoginData {
    var userId = String()
    var name = String()
    var email = String()
    var mobile = String()
    var status = String()
    
    init(loginDataJson:JSON) {
        self.userId = loginDataJson["userId"].stringValue
        self.name = loginDataJson["name"].stringValue
        self.email = loginDataJson["email"].stringValue
        self.mobile = loginDataJson["mobile"].stringValue
        self.status = loginDataJson["status"].stringValue
    }
}

// Singup Response
class SignupClass {
    var message = String()
    var status = String()
    var dataClass:SignupData? = nil
    
    init(signupJson:JSON) {
        self.message = signupJson["message"].stringValue
        self.status = signupJson["status"].stringValue
        self.dataClass = SignupData(signupDataJson: signupJson["data"])
    }
}

class SignupData {
    var userId = String()
    var name = String()
    var email = String()
    var mobile = String()
    var status = String()
    
    init(signupDataJson:JSON) {
        self.userId = signupDataJson["userId"].stringValue
        self.name = signupDataJson["name"].stringValue
        self.email = signupDataJson["email"].stringValue
        self.mobile = signupDataJson["mobile"].stringValue
        self.status = signupDataJson["status"].stringValue
    }
}

// Forgot Password Response
class ForgotClass {
    var message = String()
    var status = String()
    var dataClass:ForgotData? = nil
    
    init(forgotJson:JSON) {
        self.message = forgotJson["message"].stringValue
        self.status = forgotJson["status"].stringValue
        self.dataClass = ForgotData(forgotDataJson: forgotJson["data"])
    }
}

class ForgotData {
    var userId = String()
    var name = String()
    var email = String()
    var mobile = String()
    var status = String()
    
    init(forgotDataJson:JSON) {
        self.userId = forgotDataJson["userId"].stringValue
        self.name = forgotDataJson["name"].stringValue
        self.email = forgotDataJson["email"].stringValue
        self.mobile = forgotDataJson["mobile"].stringValue
        self.status = forgotDataJson["status"].stringValue
    }
}

// All Notes List
class AllNotesClass {
    var message = String()
    var status = String()
    var dataJson:JSON?
    var dataArray : [AllNotesData] = []
    
    
    init(allNoteJson:JSON) {
        self.message = allNoteJson["message"].stringValue
        self.status = allNoteJson["status"].stringValue
        self.dataJson = allNoteJson["data"]
        if let dataJson = self.dataJson{
            for i in 0..<dataJson.count{
                let singleData = AllNotesData(allNoteDataJson: dataJson[i])
                self.dataArray.append(singleData)
            }
        }
    }
}

class AllNotesData {
    var catId = String()
    var catName = String()
    var noteListJson:JSON?
    var noteListArray:[AllNoteList] = []
    var email = String()
    var mobile = String()
    var status = String()
    
    init(allNoteDataJson:JSON) {
        self.catId = allNoteDataJson["catId"].stringValue
        self.catName = allNoteDataJson["catName"].stringValue
        self.email = allNoteDataJson["email"].stringValue
        self.mobile = allNoteDataJson["mobile"].stringValue
        self.status = allNoteDataJson["status"].stringValue
        self.noteListJson = allNoteDataJson["noteList"]
        if let noteListJson = self.noteListJson{
            for i in 0..<noteListJson.count{
                let singleData = AllNoteList(allNoteListJson: noteListJson[i])
                self.noteListArray.append(singleData)
            }
        }
    }
}

class AllNoteList{
    var id = String()
    var title = String()
    var desc = String()
    var catId = String()
    var catName = String()
    var createDate = String()
    
    init(allNoteListJson:JSON) {
        self.id = allNoteListJson["id"].stringValue
        self.title = allNoteListJson["title"].stringValue
        self.desc = allNoteListJson["desc"].stringValue
        self.catId = allNoteListJson["catId"].stringValue
        self.catName = allNoteListJson["catName"].stringValue
        self.createDate = allNoteListJson["createDate"].stringValue
    }
}

// Note List By Category
class NoteListByCatClass{
    var message = String()
    var status = String()
    var dataJson:JSON?
    var noteListByCatArray : [NoteListByCatData] = []
    
    init(allNoteJson:JSON) {
        self.message = allNoteJson["message"].stringValue
        self.status = allNoteJson["status"].stringValue
        self.dataJson = allNoteJson["data"]
        if let dataJson = self.dataJson{
            for i in 0..<dataJson.count{
                let singleData = NoteListByCatData(allNoteListJson: dataJson[i])
                self.noteListByCatArray.append(singleData)
            }
        }
    }
}

class NoteListByCatData{
    var id = String()
    var title = String()
    var desc = String()
    var catId = String()
    var catName = String()
    var createDate = String()
    
    init(allNoteListJson:JSON) {
        self.id = allNoteListJson["id"].stringValue
        self.title = allNoteListJson["title"].stringValue
        self.desc = allNoteListJson["desc"].stringValue
        self.catId = allNoteListJson["catId"].stringValue
        self.catName = allNoteListJson["catName"].stringValue
        self.createDate = allNoteListJson["createDate"].stringValue
    }
}

// Single Note Details
class SingleNoteDetailClass{
    var message = String()
    var status = String()
    var singleNotedata:SingleNoteData? = nil
    
    init(singleNoteJson:JSON) {
        self.message = singleNoteJson["message"].stringValue
        self.status = singleNoteJson["status"].stringValue
        self.singleNotedata = SingleNoteData(singleNoteDataJson: singleNoteJson["data"])
    }
}

class SingleNoteData{
    var id = String()
    var userId = String()
    var catId = String()
    var title = String()
    var description = String()
    var createDate = String()
    
    init(singleNoteDataJson:JSON) {
        self.id = singleNoteDataJson["id"].stringValue
        self.userId = singleNoteDataJson["userId"].stringValue
        self.catId = singleNoteDataJson["catId"].stringValue
        self.title = singleNoteDataJson["title"].stringValue
        self.description = singleNoteDataJson["description"].stringValue
        self.createDate = singleNoteDataJson["createDate"].stringValue
    }
}

// Delete Single Note Class
class DeleteNoteClass{
    var message = String()
    var status = String()
    
    init(deleteJson:JSON) {
        self.message = deleteJson["message"].stringValue
        self.status = deleteJson["status"].stringValue
    }
}

// Trash List Class
class TrashListClass{
    var message = String()
    var status = String()
    var dataJson: JSON?
    var trashDataArray : [TrashListData] = []
    init(trashListJson:JSON) {
        self.message = trashListJson["message"].stringValue
        self.status = trashListJson["status"].stringValue
        self.dataJson = trashListJson["data"]
        if let dataJson = self.dataJson{
            for i in 0..<dataJson.count{
                let singletrash = TrashListData(trashDataJson: dataJson[i])
                self.trashDataArray.append(singletrash)
            }
        }
    }
}

class TrashListData{
    var id = String()
    var title = String()
    var desc = String()
    var catId = String()
    var catName = String()
    var createDate = String()
    
    init(trashDataJson:JSON) {
        self.id = trashDataJson["id"].stringValue
        self.title = trashDataJson["title"].stringValue
        self.desc = trashDataJson["desc"].stringValue
        self.catId = trashDataJson["catId"].stringValue
        self.catName = trashDataJson["catName"].stringValue
        self.createDate = trashDataJson["createDate"].stringValue
    }
}

// Category List Class
class CategoryListClass{
    var message = String()
    var status = String()
    var dataJson: JSON?
    var categoryDataArray : [CatregoryListData] = []
    init(categoryListJson:JSON) {
        self.message = categoryListJson["message"].stringValue
        self.status = categoryListJson["status"].stringValue
        self.dataJson = categoryListJson["data"]
        if let dataJson = self.dataJson{
            for i in 0..<dataJson.count{
                let singletrash = CatregoryListData(categoryDataJson: dataJson[i])
                self.categoryDataArray.append(singletrash)
            }
        }
    }
}

class CatregoryListData{
    var id = String()
    var catName = String()
    
    init(categoryDataJson:JSON) {
        self.id = categoryDataJson["id"].stringValue
        self.catName = categoryDataJson["catName"].stringValue
        
    }
}

// Create Note
class CreateNoteClass{
    var message = String()
    var status = String()
    
    init(createNoteJson:JSON) {
        self.message = createNoteJson["message"].stringValue
        self.status = createNoteJson["status"].stringValue
    }
}

// Search Note
class SearchClass{
    var message = String()
    var status = String()
    var dataJson: JSON?
    var searchDataArray : [SearchData] = []
    init(searchListJson:JSON) {
        self.message = searchListJson["message"].stringValue
        self.status = searchListJson["status"].stringValue
        self.dataJson = searchListJson["data"]
        if let dataJson = self.dataJson{
            for i in 0..<dataJson.count{
                let singletrash = SearchData(searchDataJson: dataJson[i])
                self.searchDataArray.append(singletrash)
            }
        }
    }
}

class SearchData{
    var id = String()
    var title = String()
    var description = String()
    var catId = String()
    var catName = String()
    var createDate = String()
    
    init(searchDataJson:JSON) {
        self.id = searchDataJson["id"].stringValue
        self.title = searchDataJson["title"].stringValue
        self.description = searchDataJson["description"].stringValue
        self.catId = searchDataJson["catId"].stringValue
        self.catName = searchDataJson["catName"].stringValue
        self.createDate = searchDataJson["createDate"].stringValue
    }
}

// Delete Trash Data
class DeleteTrashClass{
    var message = String()
    var status = String()
    
    init(deleteTrashJson:JSON) {
        self.message = deleteTrashJson["message"].stringValue
        self.status = deleteTrashJson["status"].stringValue
    }
}

// Edit Note Classs
class EditNoteClass{
    var message = String()
    var status = String()
    
    init(editJson:JSON) {
        self.message = editJson["message"].stringValue
        self.status = editJson["status"].stringValue
    }
}

// Recover Note
class RecoverClass{
    var message = String()
    var status = String()
    
    init(recoverJson:JSON) {
        self.message = recoverJson["message"].stringValue
        self.status = recoverJson["status"].stringValue
    }
}

// View Profile
class ViewProfileClass{
    var message = String()
    var status = String()
    var profileData:ViewProfileData? = nil
    init(viewProfileJson:JSON) {
        self.message = viewProfileJson["message"].stringValue
        self.status = viewProfileJson["status"].stringValue
        self.profileData = ViewProfileData(viewProfileDataJson: viewProfileJson["data"])
    }
}

class ViewProfileData{
    var userId = String()
    var name = String()
    var email = String()
    var mobile = String()
    var status = String()
    
    init(viewProfileDataJson:JSON) {
        self.userId = viewProfileDataJson["userId"].stringValue
        self.name = viewProfileDataJson["name"].stringValue
        self.email = viewProfileDataJson["email"].stringValue
        self.mobile = viewProfileDataJson["mobile"].stringValue
        self.status = viewProfileDataJson["status"].stringValue
    }
}

// Change Password
class ChangePasswordClass{
    var message = String()
    var status = String()
    var changePasswordData:ChangePasswordData? = nil
    
    init(ChangePasswordJson:JSON) {
        self.message = ChangePasswordJson["message"].stringValue
        self.status = ChangePasswordJson["status"].stringValue
        self.changePasswordData = ChangePasswordData(changePasswordDataJson: ChangePasswordJson["data"])
    }
}

class ChangePasswordData{
    var userId = String()
    var name = String()
    var email = String()
    var mobile = String()
    var status = String()
    
    init(changePasswordDataJson:JSON) {
        self.userId = changePasswordDataJson["userId"].stringValue
        self.name = changePasswordDataJson["name"].stringValue
        self.email = changePasswordDataJson["email"].stringValue
        self.mobile = changePasswordDataJson["mobile"].stringValue
        self.status = changePasswordDataJson["status"].stringValue
    }
}
