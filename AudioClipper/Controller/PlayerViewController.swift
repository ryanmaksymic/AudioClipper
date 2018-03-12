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
  var episodeURL: URL?
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
    episodeURL = URL.init(fileURLWithPath: Bundle.main.path(forResource: episode.fileName, ofType: "mp3")!)
    AudioManager.shared.startPlaying(url: episodeURL!, atTime: episode.progress)
    // TODO: Don't play episode if it is already playing
    // TODO: Keep episode.progress updated to resume playing an episode where you left off
  }
  
  private func updatePlayerInterface() {
    artworkImageView.image = UIImage(data: episode.artwork!)
    fileNameLabel.text = episode.episodeName
    updateTimeProgress()
    totalTimeLabel.text = AudioManager.shared.durationString
    playPauseButton.setBackgroundImage(UIImage(named: AudioManager.shared.isPlaying ? "pause" : "play"), for: .normal)
  }
  
  private func updateTimeProgress() {
    currentTimeLabel.text = AudioManager.shared.currentTimeString
    timeProgressView.progress = AudioManager.shared.progress
  }
  
  private func startProgressTimer() {
    updateTimeProgressTimer = Timer.scheduledTimer(withTimeInterval: 1.0,
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
  
  private func saveBookmark(episode: Episode, timestamp: TimeInterval, timestampString: String, comment: String) -> Bool {
    let data: [String:Any] = [R.episode:episode, R.timestamp:timestamp, R.timestampString:timestampString, R.comment:comment]
    guard DataManager.create(entity: R.Bookmark, withData: data) else {
      print("Error saving bookmark")
      return false
    }
    return true
  }
  
  private func showSavedBookmarkAlert() {
    
    let popupFrame = CGRect(x: self.view.center.x - 100, y: self.view.center.y - 50, width: 200, height: 100)
    let popup = UIView(frame: popupFrame)
    popup.backgroundColor = UIColor.darkGray
    popup.alpha = 0.98
    
    let popupLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    popupLabel.center = CGPoint(x: 100, y: 50)
    popupLabel.textColor = .white
    popupLabel.textAlignment = .center
    popupLabel.font = UIFont.boldSystemFont(ofSize: 17)
    popupLabel.text = "Bookmarked saved!"
    popup.addSubview(popupLabel)
    
    self.view.addSubview(popup)
    
    UIView.animate(withDuration: 0.5, delay: 2, options: [], animations: {
      popup.alpha = 0
    }) { (completed) in
      popup.removeFromSuperview()
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
    let bookmarkAlert = UIAlertController(title: "New Bookmark", message: "\(episode.podcastName!)\n\(episode.episodeName!)\n\(AudioManager.shared.currentTimeString!)", preferredStyle: .alert)
    bookmarkAlert.addTextField { (textField) in
      textField.placeholder = "Add a comment if you like"
      textField.textAlignment = .center
    }
    bookmarkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
      if wasPlaying { self.resumePlayer() }
    }))
    bookmarkAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
      if self.saveBookmark(episode: self.episode, timestamp: AudioManager.shared.currentTime!, timestampString: AudioManager.shared.currentTimeString!, comment: bookmarkAlert.textFields!.first!.text!) {
        print("currentTime = \(AudioManager.shared.currentTime!)")
        self.showSavedBookmarkAlert()
      }
      if wasPlaying { self.resumePlayer() }
    }))
    self.present(bookmarkAlert, animated: true, completion: nil)
  }
}


// MARK: - AVAudioPlayerDelegate

extension PlayerViewController : AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    episode.progress = 0
    updateTimeProgressTimer.invalidate()
  }
}
