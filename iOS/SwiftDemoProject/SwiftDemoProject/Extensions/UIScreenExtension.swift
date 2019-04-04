//
//  UIScreenExtension.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit

extension UIScreen {
  class func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
  }
  
  class func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
  }
}
