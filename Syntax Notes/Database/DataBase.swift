//
//  DataBase.swift
//  Hella.
//
//  Created by mac on 4/14/18.
//  Copyright © 2018 technoBrix. All rights reserved.
//

import UIKit
import CoreData

class DataBase  {
    var entity_name:String! = nil
    var appDelegate:AppDelegate! = nil
    var managedContext:NSManagedObjectContext! = nil
    var entity:NSEntityDescription! = nil
    var myList:[NSManagedObject]!  = nil
    
    required init(entity:String) {
        self.entity_name = entity
        appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        self.managedContext =
            appDelegate.persistentContainer.viewContext
        self.entity =
            NSEntityDescription.entity(forEntityName: self.entity_name,
                                       in: managedContext)!
    }
    func selectMultiple() {
        getAllRecord();
    }
    
    func selectedRecord(id:AnyObject,entityType:String) {
        getAllRecordByID(id:id,entityType:entityType)
    }
    
    func deleteAllRecord() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity_name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext.execute(request)
            try managedContext.save()
        } catch {
        }
    }
    func deleteAllSelectedRecord(id:AnyObject,entityType:String) {
        switch entityType {
        case "Notes":
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity_name)
            fetch.predicate = NSPredicate(format: "note_id = %@", id as! String)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedContext.execute(request)
                try managedContext.save()
            } catch {
                //  print ("There was an error")
            }
        default:
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity_name)
            fetch.predicate = NSPredicate(format: "trash_id = %@", id as! String)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedContext.execute(request)
                try managedContext.save()
            } catch {
                //  print ("There was an error")
            }
        }
    }
    
    func getAllRecordByID(id:AnyObject,entityType:String) {
        switch entityType {
        case "Notes" :
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
            fetchRequest.predicate = NSPredicate(format: "note_id = %@", id as! String)
            do {
                let bulkRecord  = try managedContext.fetch(fetchRequest)
                self.myList = bulkRecord as! [NSManagedObject]
            } catch _ as NSError {
                //print("Could not fetch. \(error), \(error.userInfo)")
            }
        default:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
            fetchRequest.predicate = NSPredicate(format: "trash_id = %@", id as! String)
            do {
                let bulkRecord  = try managedContext.fetch(fetchRequest)
                self.myList = bulkRecord as! [NSManagedObject]
            } catch _ as NSError {
                //print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func insertRecord(title:AnyObject, noteBody:AnyObject, noteId:AnyObject,entityType:String) {
        switch entityType {
        case "Notes":
            let record = NSManagedObject(entity: entity, insertInto: managedContext)
            
            record.setValue(validateValue(data: title), forKeyPath: "note_title")
            record.setValue(validateValue(data: noteBody), forKeyPath: "note_body")
            record.setValue(validateValue(data: noteId), forKeyPath: "note_id")
            saveData()
        default:
            let record = NSManagedObject(entity: entity, insertInto: managedContext)
            
            record.setValue(validateValue(data: title), forKeyPath: "trash_title")
            record.setValue(validateValue(data: noteBody), forKeyPath: "trash_body")
            record.setValue(validateValue(data: noteId), forKeyPath: "trash_id")
            saveData()
        }
    }
    
    func updateRecord(title:AnyObject, noteBody:AnyObject, noteId:AnyObject){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
        fetchRequest.predicate = NSPredicate(format: "note_id = %@", noteId as! String)
        do{
            let test = try managedContext.fetch(fetchRequest)
            if test.count == 1 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(validateValue(data: title), forKeyPath: "note_title")
                objectUpdate.setValue(validateValue(data: noteBody), forKeyPath: "note_body")
                objectUpdate.setValue(validateValue(data: noteId), forKeyPath: "note_id")
                saveData()
            }
        } catch {
            print(error)
        }
    }
    func validateValue(data:AnyObject) -> String {
        if data is String {
            return data as! String
        } else {
            return ""
        }
    }
    
    //////////////////////////////////////DataBase Method///////////////////////////////////////////////////////////
    
    func getAllRecord() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
        
        do {
            let bulkRecord  = try managedContext.fetch(fetchRequest)
            self.myList = bulkRecord as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData()  {
        do {
            try self.managedContext.save()
        } catch  _ as NSError {
            // print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
