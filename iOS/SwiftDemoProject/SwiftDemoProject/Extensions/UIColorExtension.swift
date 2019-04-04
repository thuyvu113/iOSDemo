//
//  UIColorExtension.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(RGBA color: [Int]) {
    let red = CGFloat(color[0]) / 255.0
    let green = CGFloat(color[1]) / 255.0
    let blue = CGFloat(color[2]) / 255.0
    let alpha = CGFloat(color[3]) / 100.0
    
    self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
  }
}
