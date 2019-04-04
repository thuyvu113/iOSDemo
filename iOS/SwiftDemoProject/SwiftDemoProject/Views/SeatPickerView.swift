//
//  SeatPickerView.swift
//  SwiftDemoProject
//

//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SeatPickerViewDelegate: class {
  func checkoutTicket(_ ticket: Ticket)
}

class SeatPickerView: UIView {
  private let disposeBag = DisposeBag()
  var viewModel: SeatPickerViewModel!
  
  weak var delegate: SeatPickerViewDelegate?
  
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  
  @IBOutlet weak var coverImage: UIImageView!
  @IBOutlet weak var coverMaskView: UIView!
  @IBOutlet weak var topBgView: UIView!
  @IBOutlet weak var seatView: UIView!
  @IBOutlet weak var editBtn: UIButton!
  
  @IBOutlet weak var checkoutBtn: UIButton!
  
  @IBOutlet weak var topViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topViewTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var topViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var coverView: UIView!
  
  var anchorRect: CGRect?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewModel = SeatPickerViewModel()
    
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
    
    bindViewModel()
  }
  
  @IBAction func editButtonDidTap(_ sender: Any) {
    hideView()
  }
  
  @IBAction func checkoutBtnDidTap(_ sender: Any) {
    self.delegate?.checkoutTicket(viewModel.getTicketForNext())
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.hideView()
    }
  }
  
  func bindViewModel() {
    viewModel.movieTitle.asObservable().bind(to: movieTitleLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieLocation.asObservable().bind(to: locationLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieDateTime.asObservable().bind(to: dateTimeLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieCover.asObservable().bind(to: coverImage.rx.image).disposed(by: disposeBag)
    viewModel.numberOfSelectedSeat.map({$0 > 0}).bind(to: checkoutBtn.rx.isEnabled).disposed(by: disposeBag)    
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
    let seatSpace: CGFloat = 9
    let aisleSpace: CGFloat = 20
    let startX = (UIScreen.screenWidth() - 14 * 2 - (14 * 15 + 11 * seatSpace + 2 * aisleSpace)) / 2
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
          x += 15
          x += seatSpace
        }
        let seat = UIButton(type: .custom)
        seat.frame = CGRect(x: x, y: y, width: 15, height: 15)
        seat.setImage(UIImage(named: "seat_empty"), for: .normal)
        seat.contentMode = .scaleAspectFit
        seatView.addSubview(seat)
        seat.addTarget(self, action: #selector(didSelectedSeat(_:)), for: .touchUpInside)
        let tag = createTag(row: i, column: j)
        seat.tag = tag
        viewModel.seatNames[tag] = "\(rowNames[i-1])\(j)"
          
        x += 15
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
      
      y += 15
      if i == 4 || i == 8 {
        y += aisleSpace
      } else {
        y += seatSpace
      }
    }
  }
  
  @objc func didSelectedSeat(_ sender: UIButton) {
    if viewModel.selectedSeats.contains(sender) {
      sender.setImage(UIImage(named: "seat_empty"), for: .normal)
      viewModel.removeSelectedSeat(sender)
    } else {
      sender.setImage(UIImage(named: "seat_selected"), for: .normal)
      viewModel.addSelectedSeat(sender)
    }
  }
  
  func clearSelectedSeats() {
    for seat in viewModel.selectedSeats {
      (seat as! UIButton).setImage(UIImage(named: "seat_empty"), for: .normal)
    }
    viewModel.clearAllSelectedSeats()
  }
  
  func createTag(row: Int, column: Int) -> Int {
    let string = "\(row)\(column)"
    return Int(string)!
  }
  
}
