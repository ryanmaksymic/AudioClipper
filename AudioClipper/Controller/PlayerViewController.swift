//
//  PlayerViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class PlayerViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var fileNameLabel: UILabel!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var timeProgressView: UIProgressView!
  @IBOutlet weak var playPauseButton: UIButton!
  
  var episode: Episode!
  var updateTimeProgressTimer: Timer!
  var bookmark: NSManagedObject?
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startPlayingEpisode()
    updatePlayerInterface()
    startProgressTimer()
  }
  
  
  // MARK: - Private methods
  
  private func startPlayingEpisode() {
    // Start playing selected episode only if it is not already playing:
    if AudioManager.shared.url != episode.url {
      AudioManager.shared.startPlaying(url: episode.url)
    }
  }
  
  private func updatePlayerInterface() {
    fileNameLabel.text = episode.title
    artworkImageView.image = episode.artwork
    totalTimeLabel.text = AudioManager.shared.durationString
    playPauseButton.setBackgroundImage(UIImage(named: AudioManager.shared.isPlaying ? "pause" : "play"), for: .normal)
  }
  
  private func updateTimeProgress() {
    currentTimeLabel.text = AudioManager.shared.currentTimeString
    timeProgressView.progress = AudioManager.shared.progress
  }
  
  private func startProgressTimer() {
    updateTimeProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                                   repeats: true,
                                                   block: { (timer) in
                                                    self.updateTimeProgress()})
  }
  
  private func resumePlayer() {
    AudioManager.shared.resume()
    startProgressTimer()
    playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
  }
  
  private func pausePlayer() {
    AudioManager.shared.pause()
    updateTimeProgressTimer.invalidate()
    playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
  }
  
  private func saveBookmark(podcastName: String, episodeName: String, timestamp: TimeInterval, timestampString: String, comment: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: R.bookmark, in: managedContext)!
    let bookmark = NSManagedObject(entity: entity, insertInto: managedContext)
    bookmark.setValue(podcastName, forKeyPath: R.podcastName)
    bookmark.setValue(episodeName, forKeyPath: R.episodeName)
    bookmark.setValue(timestamp, forKeyPath: R.timestamp)
    bookmark.setValue(timestampString, forKeyPath: R.timestampString)
    bookmark.setValue(comment, forKeyPath: R.comment)
    do {
      try managedContext.save()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  
  // MARK: - Actions
  
  @IBAction func playPause(_ sender: UIButton) {
    if AudioManager.shared.isPlaying { pausePlayer() } else { resumePlayer() }
  }
  
  @IBAction func backward(_ sender: UIButton) {
    AudioManager.shared.backward()
    updateTimeProgress()
  }
  
  @IBAction func forward(_ sender: UIButton) {
    AudioManager.shared.forward()
    updateTimeProgress()
  }
  
  @IBAction func bookmark(_ sender: UIButton) {
    var wasPlaying = false
    if AudioManager.shared.isPlaying {
      pausePlayer()
      wasPlaying = true
    }
    let bookmarkAlert = UIAlertController(title: "New Bookmark", message: "\(episode.podcast)\n\(episode.title)\n\(AudioManager.shared.currentTimeString!)", preferredStyle: .alert)
    bookmarkAlert.addTextField { (textField) in
      textField.placeholder = "Add a comment if you like"
      textField.textAlignment = .center
    }
    bookmarkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
      if wasPlaying { self.resumePlayer() }
    }))
    bookmarkAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
      self.saveBookmark(podcastName: self.episode.podcast, episodeName: self.episode.title, timestamp: AudioManager.shared.currentTime!, timestampString: AudioManager.shared.currentTimeString!, comment: bookmarkAlert.textFields!.first!.text!)
      if wasPlaying { self.resumePlayer() }
    }))
    self.present(bookmarkAlert, animated: true, completion: nil)
  }
}


// MARK: - AVAudioPlayerDelegate

extension PlayerViewController : AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    updateTimeProgressTimer.invalidate()
  }
}
