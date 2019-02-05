//
//  SeatPickerView.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-04.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SeatPickerView: UIView {
  private let disposeBag = DisposeBag()
  var viewModel: SeatPickerViewModel?
  
  @IBOutlet weak var coverImage: UIImageView!
  @IBOutlet weak var coverMaskView: UIView!
  @IBOutlet weak var topBgView: UIView!
  @IBOutlet weak var seatView: UIView!
  @IBOutlet weak var editBtn: UIButton!
  
  
  @IBOutlet weak var topViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topViewTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var topViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var coverView: UIView!
  
  var anchorRect: CGRect?
  var selectedSeats: NSMutableSet = NSMutableSet()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    topBgView.backgroundColor = UIColor(RGBA: [229, 57, 53, 100])
    topBgView.layer.masksToBounds = true
    
    coverMaskView.backgroundColor = .clear
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth(), height: 167)
    gradient.colors = [UIColor(RGBA: [229, 57, 53, 0]).cgColor,
                       UIColor(RGBA: [229, 57, 53, 100]).cgColor]
    coverMaskView.layer.addSublayer(gradient)
    
    editBtn.layer.addShadow(color: UIColor(RGBA: [0, 0, 0, 31]), x: 0, y: 8, blur: 10)
    
    buildSeatView()
  }
  
  @IBAction func editButtonDidTap(_ sender: Any) {
    hideView()
  }
  
  private func collapseViewToRect(_ frame: CGRect) {
    topViewLeadingConstraint.constant = frame.origin.x
    topViewTopConstraint.constant = frame.origin.y
    topViewTrailingConstraint.constant = -1 * (UIScreen.screenWidth() - frame.maxX)
    topViewBottomConstraint.constant = UIScreen.screenHeight() - frame.maxY
    topBgView.layer.cornerRadius = frame.size.width / 2
    bottomViewBottomConstraint.constant = 64
    self.layoutIfNeeded()
  }
  
  func showView(fromRect: CGRect) {
    coverView.alpha = 1.0
    self.anchorRect = fromRect
    collapseViewToRect(fromRect)

    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      self.topViewLeadingConstraint.constant = 0
      self.topViewTopConstraint.constant = 0
      self.topViewTrailingConstraint.constant = 0
      self.topViewBottomConstraint.constant = 64
      self.topBgView.layer.cornerRadius = 0
      self.bottomViewBottomConstraint.constant = 0
      self.coverView.alpha = 0
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  func hideView() {
    if let anchorRect = anchorRect {
      coverView.alpha = 0.0
      UIView.animate(withDuration: 0.3, animations: {
        self.collapseViewToRect(anchorRect)
        self.coverView.alpha = 1.0
      }) { _ in
        self.clearSelectedSeats()
        self.removeFromSuperview()
      }
    }
  }
  
  func buildSeatView() {
    let rowNames = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    let seatSpace: CGFloat = 11
    let aisleSpace: CGFloat = 20
    let startX = (UIScreen.screenWidth() - 14 * 2 - (14 * 11 + 11 * seatSpace + 2 * aisleSpace)) / 2
    var x: CGFloat = startX
    var y: CGFloat = 0
    for i in 1...9 {
      for j in 1...12 {
        if j == 1 {
          let rowLabel = UILabel(frame: CGRect(x: 0, y: y, width: 11, height: 11))
          rowLabel.text = rowNames[i-1]
          rowLabel.font = UIFont.systemFont(ofSize: 13)
          rowLabel.textColor = UIColor(RGBA: [221, 148, 148, 100])
          rowLabel.textAlignment = .center
          seatView.addSubview(rowLabel)
          x += 11
          x += seatSpace
        }
        let seat = UIButton(type: .custom)
        seat.frame = CGRect(x: x, y: y, width: 11, height: 11)
        seat.setImage(UIImage(named: "seat_empty"), for: .normal)
        seatView.addSubview(seat)
        seat.addTarget(self, action: #selector(didSelectedSeat(_:)), for: .touchUpInside)
        x += 11
        if j == 2 || j == 10 {
          x += aisleSpace
        } else {
          x += seatSpace
        }
        
        if j == 12 {
          let rowLabel = UILabel(frame: CGRect(x: UIScreen.screenWidth() - 14 * 2 - 11, y: y, width: 11, height: 11))
          rowLabel.text = rowNames[i-1]
          rowLabel.font = UIFont.systemFont(ofSize: 13)
          rowLabel.textColor = UIColor(RGBA: [221, 148, 148, 100])
          rowLabel.textAlignment = .center
          seatView.addSubview(rowLabel)
          x = startX
        }
      }
      
      y += 11
      if i == 4 || i == 8 {
        y += aisleSpace
      } else {
        y += seatSpace
      }
    }
  }
  
  @objc func didSelectedSeat(_ sender: UIButton) {
    if selectedSeats.contains(sender) {
      sender.setImage(UIImage(named: "seat_empty"), for: .normal)
      selectedSeats.remove(sender)
    } else {
      sender.setImage(UIImage(named: "seat_selected"), for: .normal)
      selectedSeats.add(sender)
    }
  }
  
  func clearSelectedSeats() {
    for seat in selectedSeats {
      (seat as! UIButton).setImage(UIImage(named: "seat_empty"), for: .normal)
    }
    selectedSeats.removeAllObjects()
  }
}
