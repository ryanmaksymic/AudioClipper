//
//  PlayerViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import AVFoundation

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
  var bookmark: Bookmark?
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startPlaying()
    updatePlayerInterface()
    startUpdateTimeProgressTimer()
  }
  
  
  // MARK: - Private methods
  
  private func startPlaying() {
    // Start playing selected episode if it is not already playing:
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
  
  private func startUpdateTimeProgressTimer() {
    updateTimeProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                                   repeats: true,
                                                   block: { (timer) in
                                                    self.updateTimeProgress()})
  }
  
  private func resumePlayer() {
    AudioManager.shared.resume()
    startUpdateTimeProgressTimer()
    playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
  }
  
  private func pausePlayer() {
    AudioManager.shared.pause()
    updateTimeProgressTimer.invalidate()
    playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
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
    if AudioManager.shared.isPlaying { pausePlayer() }
    let bookmarkAlert = UIAlertController(title: "New Bookmark", message: "\(episode.podcast)\n\(episode.title)\n\(AudioManager.shared.currentTimeString!)", preferredStyle: .alert)
    bookmarkAlert.addTextField { (textField) in
      textField.placeholder = "Add a comment if you like"
      textField.textAlignment = .center
    }
    bookmarkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    bookmarkAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
      self.bookmark = Bookmark(episode: self.episode, timestamp: AudioManager.shared.currentTime!, timestampString: AudioManager.shared.currentTimeString!, comment: bookmarkAlert.textFields?.first?.text)
      self.performSegue(withIdentifier: "ShowBookmarks", sender: nil)
      
      // TODO: Save new Bookmark object to CoreData; maybe don't segue?
      
    }))
    self.present(bookmarkAlert, animated: true, completion: nil)
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowBookmarks" {
      if let btvc = segue.destination as? BookmarksTableViewController {
        btvc.bookmarks.append(bookmark!)
      }
    }
  }
}


// MARK: - AVAudioPlayerDelegate

extension PlayerViewController : AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    updateTimeProgressTimer.invalidate()
  }
}
