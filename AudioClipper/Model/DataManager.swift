//
//  DataManager.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-11.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import CoreData

// Data keys:
enum R {
  // Bookmarks:
  static let Bookmark = "Bookmark"
  static let comment = "comment"
  static let timestamp = "timestamp"
  static let timestampString = "timestampString"
  static let episode = "episode"
  
  // Episodes:
  static let Episode = "Episode"
  static let artwork = "artwork"
  static let episodeName = "episodeName"
  static let fileName = "fileName"
  static let podcastName = "podcastName"
  static let progress = "progress"
}

class DataManager {
  
  // MARK: - Class methods
  
  class func create(entity entityName: String, withData data: Dictionary<String, Any>) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
    let object = NSManagedObject(entity: entity, insertInto: managedContext)
    for (key, value) in data {
      object.setValue(value, forKey: key)
    }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print(error.localizedDescription)
      return false
    }
    return true
  }
  
  class func load(entities entityName: String) -> [NSManagedObject]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    do {
      return try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print(error.localizedDescription)
      return nil
    }
  }
  
  class func delete(object: NSManagedObject) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(object)
    do {
      try managedContext.save()
    } catch let error as NSError {
      print(error.localizedDescription)
      return false
    }
    return true
  }
}
