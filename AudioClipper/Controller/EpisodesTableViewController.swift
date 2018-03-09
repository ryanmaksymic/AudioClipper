//
//  EpisodesTableViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodesTableViewController: UITableViewController {
  
  // MARK: - Properties

  var episodes = [Episode]()
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadTestData()
    
    setupAudioSession()
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      // AVAudioSessionCategoryPlayback: this app's audio is not silenced by silent switch or screen locking; this app's audio interrupts other nonmixable app’s audio
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
      try audioSession.setActive(true)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  
  // MARK: - Private methods
  
  func loadTestData() {
    let episode1 = Episode(podcast: "Comedy Bang! Bang!", artwork: UIImage(named: "cbb_art")!, title: "Episode #123", url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "CBB", ofType: "mp3")!))
    let episode2 = Episode(podcast: "Hollywood Handbook", artwork: UIImage(named: "hh_art")!, title: "Episode #456", url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "HH", ofType: "mp3")!))
    let episode3 = Episode(podcast: "U Talkin' U2 To Me?", artwork: UIImage(named: "utu2tm_art")!, title: "Episode #789", url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "UTU2TM", ofType: "mp3")!))
    episodes = [episode1, episode2, episode3]
  }
  
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
    let episode = episodes[indexPath.row]
    cell.textLabel!.text = episode.podcast
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
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let pvc = segue.destination as? PlayerViewController else { return }
    pvc.episode = episodes[tableView.indexPathForSelectedRow!.row]
  }
}
