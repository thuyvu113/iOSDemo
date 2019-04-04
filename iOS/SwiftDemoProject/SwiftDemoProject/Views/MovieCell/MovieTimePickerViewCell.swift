//
//  MovieTimePickerViewCell.swift
//  SwiftDemoProject
//

//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit

class MovieTimePickerViewCell: UICollectionViewCell {
  var index: Int = -1
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    bgView.layer.cornerRadius = 4
    self.layer.masksToBounds = false
  }
  
  func selectedAtIndex(_ index: Int) {
    if self.index == index {
      bgView.backgroundColor = UIColor(RGBA: [76, 175, 80, 100])
      bgView.layer.addShadow(color: UIColor(RGBA: [76, 175, 80, 31]), x: 0, y: 3, blur: 14)
      bgView.layer.masksToBounds = false
    } else {
      bgView.backgroundColor = UIColor(RGBA: [247, 247, 247, 100])
      bgView.layer.masksToBounds = true
    }
  }
}
