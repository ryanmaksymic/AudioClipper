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
  
  var audioPlayer: AVAudioPlayer!
  var trackLength: TimeInterval!
  var updateTimeProgressTimer: Timer!
  var playing = false
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAudioPlayer()
    updatePlayerInterface()
  }
  
  
  // MARK: - Private methods
  
  func setupAudioPlayer() {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: episode.url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func updatePlayerInterface() {
    fileNameLabel.text = episode.title
    artworkImageView.image = episode.artwork
    timeProgressView.progress = 0.0
    currentTimeLabel.text = "00:00:00"
    playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
    
    trackLength = audioPlayer.duration
    totalTimeLabel.text = stringFromTimeInterval(interval: trackLength)
  }
  
  func updateTimeProgress() {
    timeProgressView.progress = Float(audioPlayer.currentTime/trackLength)
    
    currentTimeLabel.text = stringFromTimeInterval(interval: audioPlayer.currentTime)
  }
  
  func stringFromTimeInterval(interval: TimeInterval) -> String {
    var result = ""
    let ti = NSInteger(interval)
    let hours = (ti / 3600)
    let minutes = (ti / 60) % 60
    let seconds = ti % 60
    result.append(hours < 10 ? "0\(hours)" : "\(hours)")
    result.append(minutes < 10 ? ":0\(minutes)" : ":\(minutes)")
    result.append(seconds < 10 ? ":0\(seconds)" : ":\(seconds)")
    return result
  }
  
  
  // MARK: - Actions
  
  @IBAction func playPause(_ sender: UIButton) {
    if playing {
      audioPlayer.pause()
      updateTimeProgressTimer.invalidate()
      playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
    } else {
      audioPlayer.play()
      updateTimeProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                                     repeats: true,
                                                     block: { (timer) in
                                                      self.updateTimeProgress()})
      playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
    }
    playing = !playing
  }
  
  @IBAction func backward(_ sender: UIButton) {
    audioPlayer.currentTime = audioPlayer.currentTime - 30
    updateTimeProgress()
  }
  
  @IBAction func forward(_ sender: UIButton) {
    audioPlayer.currentTime = audioPlayer.currentTime + 30
    updateTimeProgress()
  }
}


// MARK: - AVAudioPlayerDelegate

extension PlayerViewController : AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    updateTimeProgressTimer.invalidate()
  }
}
