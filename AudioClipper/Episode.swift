//
//  Episode.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-07.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import Foundation

class Episode {
  
  var title: String
  var podcast: String
  var url: URL
  
  init(title: String, podcast: String, url: URL) {
    self.title = title
    self.podcast = podcast
    self.url = url
  }
}
