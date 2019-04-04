//
//  PopcornNavigationBar.swift
//  SwiftDemoProject
//
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit

class PopcornNavigationBar: UIView {

  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var settingsBtn: UIButton!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let view = Bundle.main.loadNibNamed("PopcornNavigationBar", owner: self, options: nil)?[0] as! UIView
    self.addSubview(view)

    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  func hideBackBtn() {
    backBtn.isHidden = true
  }
  
  func hideSettingsBtn() {
    settingsBtn.isHidden = true
  }
}
