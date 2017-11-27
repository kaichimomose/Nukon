//
//  CoreDataHelper.swift
//  PartyManager
//
//  Created by Kaichi Momose on 2017/11/26.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSManagedObject  {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //static methods will go here
    // For UserData
    static func newUserData() -> UserData{
        return NSEntityDescription.insertNewObject(forEntityName: "UserData", into: managedContext) as! UserData
    }
    
    static func saveUserData(){
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(userData: UserData){
        managedContext.delete(userData)
    }
    
    static func retrieveUserData() -> [UserData]{
        let fetchRequest = NSFetchRequest<UserData>(entityName: "UserData")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    // For WordLearnt
    static func newWordLearnt() -> WordLearnt{
        return NSEntityDescription.insertNewObject(forEntityName: "WordLearnt", into: managedContext) as! WordLearnt
    }
    
    static func saveWordLearnt(){
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(wordLearnt: WordLearnt){
        managedContext.delete(wordLearnt)
    }
    
    static func retrieveWordLearnt() -> [WordLearnt]{
        let fetchRequest = NSFetchRequest<WordLearnt>(entityName: "WordLearnt")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }

}
