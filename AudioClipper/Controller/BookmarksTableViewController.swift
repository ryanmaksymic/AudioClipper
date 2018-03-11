//
//  BookmarksTableViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import CoreData

// Bookmark entity keys:
enum R {
  static let bookmark = "Bookmark"
  static let comment = "comment"
  static let episodeName = "episodeName"
  static let podcastName = "podcastName"
  static let timestamp = "timestamp"
  static let timestampString = "timestampString"
}

class BookmarksTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  var bookmarks = [NSManagedObject]()
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    loadBookmarks()
  }
  
  
  // MARK: - Private methods
  
  private func loadBookmarks() {
    guard let managedContext = viewContext() else { return }
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: R.bookmark)
    do {
      bookmarks = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  private func viewContext() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
    return appDelegate.persistentContainer.viewContext
  }
  
  // TODO: Create DataManager class to handle application-wide CRUD operations
  
  
  // MARK: - UITableViewController
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookmarks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarksTableViewCell
    let bookmark = bookmarks[indexPath.row]
    cell.podcastLabel.text = bookmark.value(forKeyPath: R.podcastName) as? String
    cell.episodeTitleLabel.text = bookmark.value(forKeyPath: R.episodeName) as? String
    cell.timestampLabel.text = bookmark.value(forKeyPath: R.timestampString) as? String
    cell.commentLabel.text = bookmark.value(forKeyPath: R.comment) as? String
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //performSegue(withIdentifier: "ShowPlayer", sender: nil)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let bookmark = bookmarks[indexPath.row]
      guard let managedContext = viewContext() else { return }
      managedContext.delete(bookmark)
      do {
        try managedContext.save()
      } catch let error as NSError {
        print(error.localizedDescription)
      }
      bookmarks.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //if segue.identifier == "ShowPlayer", let pvc = segue.destination as? PlayerViewController {
    //let bookmark = bookmarks[tableView.indexPathForSelectedRow!.row]
    //pvc.episode = bookmark.episode
    // TODO: Make Episode entity in Core Data so that this works
    //}
  }
}
