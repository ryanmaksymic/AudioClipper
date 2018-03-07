//
//  ViewController.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties

  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var fileNameLabel: UILabel!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var timeProgressView: UIProgressView!
  @IBOutlet weak var playPauseButton: UIButton!
  
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fileNameLabel.text = "My Audio Track"
    timeProgressView.progress = 0.0
    currentTimeLabel.text = "00:00:00"
    totalTimeLabel.text = "59:59:59"
  }
  
  
  // MARK: - Actions
  
  @IBAction func playPause(_ sender: UIButton) {
    print("Play/Pause!")
  }
  
  @IBAction func backward(_ sender: UIButton) {
    print("Backward!")
  }
  
  @IBAction func forward(_ sender: UIButton) {
    print("Forward!")
  }
}
