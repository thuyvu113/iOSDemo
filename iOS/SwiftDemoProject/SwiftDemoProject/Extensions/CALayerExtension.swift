//
//  CALayerExtension.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-28.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
  func addShadow(color: UIColor, x: Int, y: Int, blur: CGFloat, opacity: Float = 1.0) {
    shadowColor = color.cgColor
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2
    shadowOpacity = opacity
  }
}
