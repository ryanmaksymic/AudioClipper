//
//  BookmarksTableViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import CoreData

class BookmarksTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  var bookmarks = [NSManagedObject]()
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    bookmarks = DataManager.load(entities: R.bookmark) ?? []
  }
  
  
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
      guard DataManager.delete(object: bookmark) else {
        print("Error deleting bookmark")
        return
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
