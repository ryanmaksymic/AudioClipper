//
//  ViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var fileNameLabel: UILabel!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var timeProgressView: UIProgressView!
  @IBOutlet weak var playPauseButton: UIButton!
  
  var audioPlayer: AVAudioPlayer!
  
  var playing = false
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fileNameLabel.text = "My Audio Track"
    timeProgressView.progress = 0.0
    currentTimeLabel.text = "00:00:00"
    totalTimeLabel.text = "59:59:59"
    playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
    
    prepareAudioPlayer()
  }
  
  
  // MARK: - Private methods
  
  func prepareAudioPlayer() {
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "CBB", ofType: "mp3")!))
      audioPlayer.prepareToPlay()
    } catch {
      print(error.localizedDescription)
    }
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)  // AVAudioSessionCategoryRecord: audio not silenced by silent switch or screen locking, does interrupt other nonmixable app’s audio
    } catch {
      print(error.localizedDescription)
    }
  }
  
  
  // MARK: - Actions
  
  @IBAction func playPause(_ sender: UIButton) {
    if playing {
      audioPlayer.pause()
      playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
    } else {
      audioPlayer.play()
      playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
    }
    
    playing = !playing
  }
  
  @IBAction func backward(_ sender: UIButton) {
    print("Backward!")
  }
  
  @IBAction func forward(_ sender: UIButton) {
    print("Forward!")
  }
}
