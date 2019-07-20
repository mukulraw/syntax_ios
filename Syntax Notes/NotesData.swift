//
//  NotesData.swift
//  Syntax Notes
//
//  Created by Sunny on 20/09/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation
import CoreData

class NotesData{
    var noteTitle = String()
    var noteBody = String()
    var noteId = String()
    
    init(databaseObj:NSManagedObject) {
        self.noteTitle = databaseObj.value(forKey: "note_title") as! String //(databaseObj["note_title"]?.stringValue)!
        self.noteBody = databaseObj.value(forKey: "note_body") as! String //(databaseObj["note_body"]?.stringValue)!
        self.noteId = databaseObj.value(forKey: "note_id") as! String
    }
}

class TrashData{
    var trashTitle = String()
    var trashBody = String()
    var trashId = String()
    
    init(databaseObj:NSManagedObject) {
        self.trashTitle = databaseObj.value(forKey: "trash_title") as! String //(databaseObj["note_title"]?.stringValue)!
        self.trashBody = databaseObj.value(forKey: "trash_body") as! String //(databaseObj["note_body"]?.stringValue)!
        self.trashId = databaseObj.value(forKey: "trash_id") as! String
    }
}
