//
//  EpisodesTableViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class EpisodesTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  var episodes = [Episode]()
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAudioSession()
    loadEpisodes()
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  
  // MARK: - Private methods
  
  private func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      // AVAudioSessionCategoryPlayback: this app's audio is not silenced by silent switch or screen locking; this app's audio interrupts other nonmixable app’s audio
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
      try audioSession.setActive(true)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func loadEpisodes() {
    guard let eps = DataManager.load(entities: R.Episode) as? [Episode], eps != [] else {
      print("No episodes found. Creating dummy data.")
      generateDummyData()
      loadEpisodes()
      return
    }
    episodes = eps
  }
  
  private func generateDummyData() {
    let episode1Data: [String:Any] = [
      R.artwork:UIImageJPEGRepresentation(UIImage(named: "cbb_art")!, 1)!,
      R.episodeName:"Episode #123",
      R.podcastName:"Comedy Bang! Bang!",
      R.progress:0,
      R.fileName: "CBB"]
    _ = DataManager.create(entity: R.Episode, withData: episode1Data)
    let episode2Data: [String:Any] = [
      R.artwork:UIImageJPEGRepresentation(UIImage(named: "hh_art")!, 1)!,
      R.episodeName:"Episode #456",
      R.podcastName:"Hollywood Handbook",
      R.progress:0,
      R.fileName: "HH"]
    _ = DataManager.create(entity: R.Episode, withData: episode2Data)
    let episode3Data: [String:Any] = [
      R.artwork:UIImageJPEGRepresentation(UIImage(named: "utu2tm_art")!, 1)!,
      R.episodeName:"Episode #789",
      R.podcastName:"U Talkin' U2 To Me?",
      R.progress:0,
      R.fileName:"UTU2TM"]
    _ = DataManager.create(entity: R.Episode, withData: episode3Data)
  }
  
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
    let episode = episodes[indexPath.row]
    cell.textLabel!.text = episode.podcastName
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
   */
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let pvc = segue.destination as? PlayerViewController else { return }
    pvc.episode = episodes[tableView.indexPathForSelectedRow!.row]
    pvc.episode.progress = 0
  }
}
