//
//  Episode.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit

class Episode {
  
  var podcast: String
  var artwork: UIImage
  var title: String
  var url: URL
  var progress: TimeInterval
  
  init(podcast: String, artwork: UIImage, title: String, url: URL) {
    self.podcast = podcast
    self.artwork = artwork
    self.title = title
    self.url = url
    self.progress = TimeInterval(0)
  }
}
