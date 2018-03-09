//
//  Bookmark.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit

class Bookmark {
  
  var episode: Episode
  var timestamp: TimeInterval
  var timestampString: String
  var comment: String?
  
  init(episode: Episode, timestamp: TimeInterval, timestampString: String, comment: String? = nil) {
    self.episode = episode
    self.timestamp = timestamp
    self.timestampString = timestampString
    self.comment = comment
  }
}
