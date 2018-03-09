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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem
    loadBookmarks()
  }
  
  
  // MARK: - Private methods
  
  private func loadBookmarks() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: R.bookmark)
    do {
      bookmarks = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  
  // MARK: - UITableViewDataSource
  
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
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   }
   
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
}
