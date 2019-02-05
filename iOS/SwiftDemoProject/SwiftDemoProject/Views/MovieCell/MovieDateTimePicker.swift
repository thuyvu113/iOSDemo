//
//  MovieTimePicker.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-04.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDateTimePicker: UIView {
  private let disposeBag = DisposeBag()
  var viewModel: MovieDateTimePickerViewModel?
  
  @IBOutlet weak var datePickerView: UIStackView!
  @IBOutlet weak var leftArrowBtn: UIButton!
  @IBOutlet weak var rightArrowBtn: UIButton!
  @IBOutlet weak var locationScrollView: UIScrollView!
  @IBOutlet weak var timePickerView: UICollectionView!
  
  private var datePickerControlList: [MovieDatePickerControl] = []
  private var seclectedTimeIndex: Int = -1
  
  private var locationViewList: [UILabel] = []
  private var curLocationIndex: Int = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewModel = MovieDateTimePickerViewModel()
    bindViewModel()
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let view = Bundle.main.loadNibNamed("MovieDateTimePicker", owner: self, options: nil)?[0] as! UIView
    view.frame = self.bounds
    self.addSubview(view)
  }
  
  func bindViewModel() {
    
  }
  
  func setup() {
    if let viewModel = viewModel {
      let sevenDays = viewModel.getSevenDays()
      for day in sevenDays {
        let frame = CGRect(x: 0, y: 0, width: 30, height: datePickerView.frame.size.height)
        let calendarDayView = MovieDatePickerControl(frame: frame)
        calendarDayView.setDay(day)
        calendarDayView.isSelected = false
        calendarDayView.addTarget(self, action: #selector(datePickerViewDidSelected(_:)), for: .touchUpInside)
        datePickerView.addArrangedSubview(calendarDayView)
        datePickerControlList.append(calendarDayView)
      }
      
      datePickerControlList[0].isSelected = true
    }
    
    timePickerView.register(UINib(nibName: "MovieTimePickerViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "timeCell")
    
    let frame = locationScrollView.frame
    for i in 1...4 {
      let location = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
      location.font = UIFont.boldSystemFont(ofSize: 14)
      location.textAlignment = .center
      location.text = "Location \(i + 1)"
      locationScrollView.addSubview(location)
      locationViewList.append(location)
    }
    
    leftArrowBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      if self.curLocationIndex == 0 { return }
      
      self.curLocationIndex -= 1
      let frame = self.locationViewList[self.curLocationIndex].frame
      self.locationScrollView.scrollRectToVisible(frame, animated: true)
    }.disposed(by: disposeBag)
    
    rightArrowBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      if self.curLocationIndex == self.locationViewList.count - 1 { return }
      
      self.curLocationIndex += 1
      let frame = self.locationViewList[self.curLocationIndex].frame
      self.locationScrollView.scrollRectToVisible(frame, animated: true)
    }.disposed(by: disposeBag)

  }
  
  @objc func datePickerViewDidSelected(_ sender: MovieDatePickerControl) {
    for dateView in datePickerControlList {
      dateView.isSelected = false
    }
    
    sender.isSelected = true
  }
  
  func reloadLayoutIfNeeded() {
    let frame = locationScrollView.frame
    for (index, location) in locationViewList.enumerated() {
      let x = CGFloat(index) * frame.size.width
      location.frame = CGRect(x: x, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    let width = CGFloat(locationViewList.count) * frame.size.width
    locationScrollView.contentSize = CGSize(width: width, height: frame.size.height)
  }
}


extension MovieDateTimePicker: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 16
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! MovieTimePickerViewCell
    cell.index = indexPath.row
    cell.selectedAtIndex(seclectedTimeIndex)
    return cell
  }
}

extension MovieDateTimePicker: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 75, height: 30)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}

extension MovieDateTimePicker: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    seclectedTimeIndex = indexPath.row
    collectionView.reloadData()
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
