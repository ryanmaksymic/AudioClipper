//
//  AudioManager.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import AVFoundation

class AudioManager {
  
  // MARK: - Properties
  
  static var shared = AudioManager()
  
  private var player: AVAudioPlayer?
  
  var url: URL? {
    if let player = player {
      return player.url
    }
    return nil
  }
  
  var durationString: String? {
    if let player = player {
      return stringFromTimeInterval(interval: player.duration)
    }
    return nil
  }
  
  var currentTimeString: String? {
    if let player = player {
      return stringFromTimeInterval(interval: player.currentTime)
    }
    return nil
  }
  
  var currentTime: TimeInterval? {
    if let player = player {
      return player.currentTime
    }
    return nil
  }
  
  var progress: Float {
    if let player = player {
      return Float(player.currentTime/player.duration)
    }
    return 0
  }
  
  var isPlaying: Bool {
    if let player = player {
      return player.isPlaying
    }
    return false
  }
  
  var playerInitialized: Bool {
    return player != nil
  }
  
  
  // MARK: - Public methods
  
  func startPlaying(url: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
    } catch {
      print(error)
      return
    }
    player!.play()
  }
  
  func startPlaying(url: URL, atTime time: TimeInterval) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
    } catch {
      print(error)
      return
    }
    player!.play(atTime: time)
  }
  
  // TODO: Refactor PlayerViewController, move isPlaying check into pause() and resume() (?)
  
  func pause() {
    if let player = player {
      player.pause()
    }
  }
  
  func resume() {
    if let player = player {
      player.play()
    }
  }
  
  func forward() {
    if let player = player {
      player.currentTime += 30
    }
  }
  
  func backward() {
    if let player = player {
      player.currentTime -= 30
    }
  }
  
  
  // MARK: - Private methods
  
  private func stringFromTimeInterval(interval: TimeInterval) -> String {
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
}
