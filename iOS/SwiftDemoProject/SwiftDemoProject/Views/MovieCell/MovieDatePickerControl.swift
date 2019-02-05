//
//  CalendarDayView.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-04.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit

class MovieDatePickerControl: UIControl {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var weekdayLabel: UILabel!
  @IBOutlet weak var weekdayBaseView: UIView!
  
  override var isSelected: Bool {
    didSet {
      self.hightlightView()
    }
  }
  
  func setDay(_ day: CalendarDay) {
    dayLabel.text = day.day
    weekdayLabel.text = day.weekday
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initMainView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initMainView()
  }
  
  func initMainView() {
    let view = Bundle.main.loadNibNamed("MovieDatePickerControl", owner: self, options: nil)?[0] as! UIView
    view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    self.addSubview(view)
    weekdayBaseView.layer.cornerRadius = 15
  }
  
  func hightlightView() {
    if isSelected {
      weekdayBaseView.backgroundColor = UIColor(RGBA: [76, 175, 80, 100])
      weekdayBaseView.layer.addShadow(color: UIColor(RGBA: [76, 175, 80, 31]), x: 0, y: 3, blur: 14)
      weekdayBaseView.layer.masksToBounds = false
    } else {
      weekdayBaseView.backgroundColor = .clear
      weekdayBaseView.layer.masksToBounds = true
    }
  }
}
