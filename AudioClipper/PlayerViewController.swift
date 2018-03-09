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
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    playEpisode()
    updatePlayerInterface()
    startUpdateTimeProgressTimer()
  }
  
  
  // MARK: - Private methods
  
  private func playEpisode() {
    // Start playing selected episode if it is not already playing:
    if AudioManager.shared.url != episode.url {
      AudioManager.shared.startPlaying(url: episode.url)
    }
  }
  
  private func updatePlayerInterface() {
    fileNameLabel.text = episode.title
    artworkImageView.image = episode.artwork
    totalTimeLabel.text = AudioManager.shared.duration
    playPauseButton.setBackgroundImage(UIImage(named: AudioManager.shared.isPlaying ? "pause" : "play"), for: .normal)
  }
  
  private func updateTimeProgress() {
    currentTimeLabel.text = AudioManager.shared.currentTime
    timeProgressView.progress = AudioManager.shared.progress
  }
  
  private func startUpdateTimeProgressTimer() {
    updateTimeProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                                   repeats: true,
                                                   block: { (timer) in
                                                    self.updateTimeProgress()})
  }
  
  
  // MARK: - Actions
  
  @IBAction func playPause(_ sender: UIButton) {
    if AudioManager.shared.isPlaying {
      AudioManager.shared.pause()
      updateTimeProgressTimer.invalidate()
      playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
    } else {
      AudioManager.shared.resume()
      startUpdateTimeProgressTimer()
      playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
    }
  }
  
  @IBAction func backward(_ sender: UIButton) {
    AudioManager.shared.backward()
    updateTimeProgress()
  }
  
  @IBAction func forward(_ sender: UIButton) {
    AudioManager.shared.forward()
    updateTimeProgress()
  }
}


// MARK: - AVAudioPlayerDelegate

extension PlayerViewController : AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    updateTimeProgressTimer.invalidate()
  }
}
