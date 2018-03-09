//
//  BookmarksTableViewCell.swift
//  AudioClipper
//
//  Created by Ryan Maksymic on 2018-03-08.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import UIKit

class BookmarksTableViewCell: UITableViewCell {
  
  @IBOutlet weak var podcastLabel: UILabel!
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
