//
//  MovieTimePicker.swift
//  SwiftDemoProject
//

//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDateTimePicker: UIView {
  private let disposeBag = DisposeBag()
  var viewModel: MovieDateTimePickerViewModel!
  
  @IBOutlet weak var datePickerView: UIStackView!
  @IBOutlet weak var leftArrowBtn: UIButton!
  @IBOutlet weak var rightArrowBtn: UIButton!
  @IBOutlet weak var locationScrollView: UIScrollView!
  @IBOutlet weak var timePickerView: UICollectionView!
  
  private var datePickerControlList: [MovieDatePickerControl] = []
  private var locationViewList: [UILabel] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let view = Bundle.main.loadNibNamed("MovieDateTimePicker", owner: self, options: nil)?[0] as! UIView
    view.frame = self.bounds
    self.addSubview(view)
    
    viewModel = MovieDateTimePickerViewModel()
    bindViewModel()
    setup()
  }
  
  func bindViewModel() {
    viewModel.selectedLocationIndex.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      let newLocationIndex = event.element!
      let x = CGFloat(newLocationIndex) * self.locationScrollView.frame.size.width
      self.locationScrollView.contentOffset = CGPoint(x: x, y: 0)
    }.disposed(by: disposeBag)
    
    viewModel.seclectedTimeIndex.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.timePickerView.reloadData()
    }.disposed(by: disposeBag)
    
    viewModel.selectedDateIndex.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      if self.datePickerControlList.count > 0 {
        for dateView in self.datePickerControlList {
          dateView.isSelected = false
        }
        self.datePickerControlList[event.element!].isSelected = true
      }
    }.disposed(by: disposeBag)
  
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

//MARK: Set up
extension MovieDateTimePicker {
  private func setup() {
    let sevenDays = viewModel.dates!
    for (index, day) in sevenDays.enumerated() {
      let frame = CGRect(x: 0, y: 0, width: 30, height: datePickerView.frame.size.height)
      let calendarDayView = MovieDatePickerControl(frame: frame)
      calendarDayView.setDay(day)
      calendarDayView.isSelected = false
      calendarDayView.index = index
      calendarDayView.addTarget(self, action: #selector(datePickerViewDidSelected(_:)), for: .touchUpInside)
      datePickerView.addArrangedSubview(calendarDayView)
      datePickerControlList.append(calendarDayView)
    }
    
    datePickerControlList[0].isSelected = true
    viewModel.selectedDateIndex.accept(0)
    
    timePickerView.register(UINib(nibName: "MovieTimePickerViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "timeCell")
    
    let frame = locationScrollView.frame
    if let locations = viewModel.locations {
      for location in locations {
        let locationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        locationLabel.font = UIFont.boldSystemFont(ofSize: 14)
        locationLabel.textAlignment = .center
        locationLabel.text = location.name
        locationScrollView.addSubview(locationLabel)
        locationViewList.append(locationLabel)
      }
    }
    
    
    leftArrowBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.viewModel.seclectedTimeIndex.accept(-1)
      let nextLocationIndex = self.viewModel.selectedLocationIndex.value - 1
      self.viewModel.selectedLocationIndex.accept(nextLocationIndex)
      let frame = self.locationViewList[self.viewModel.selectedLocationIndex.value].frame
      self.locationScrollView.scrollRectToVisible(frame, animated: true)
      self.timePickerView.reloadData()
      self.updateLeftRightBtnAppearence()
      }.disposed(by: disposeBag)
    
    rightArrowBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.viewModel.seclectedTimeIndex.accept(-1)
      let nextLocationIndex = self.viewModel.selectedLocationIndex.value + 1
      self.viewModel.selectedLocationIndex.accept(nextLocationIndex)
      let frame = self.locationViewList[self.viewModel.selectedLocationIndex.value].frame
      self.locationScrollView.scrollRectToVisible(frame, animated: true)
      self.timePickerView.reloadData()
      
      self.updateLeftRightBtnAppearence()
      }.disposed(by: disposeBag)
    
    self.updateLeftRightBtnAppearence()
  }
  
  private func updateLeftRightBtnAppearence() {
    if self.viewModel.selectedLocationIndex.value == 0 {
      self.leftArrowBtn.isEnabled = false
      self.leftArrowBtn.alpha = 0
    } else if self.viewModel.selectedLocationIndex.value == self.locationViewList.count - 1 {
      self.rightArrowBtn.isEnabled = false
      self.rightArrowBtn.alpha = 0
    } else {
      self.leftArrowBtn.isEnabled = true
      self.leftArrowBtn.alpha = 1
      self.rightArrowBtn.isEnabled = true
      self.rightArrowBtn.alpha = 1
    }
  }
  
  @objc private func datePickerViewDidSelected(_ sender: MovieDatePickerControl) {
    viewModel.selectedDateIndex.accept(sender.index)
  }
}

//MARK: Time picker - Collection View
extension MovieDateTimePicker: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.getNumberOfShowTimes()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! MovieTimePickerViewCell
    cell.index = indexPath.row
    cell.timeLabel.text = viewModel.getShowTimeString(atIndex: indexPath.row)
    cell.selectedAtIndex(viewModel.seclectedTimeIndex.value)
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
    viewModel.seclectedTimeIndex.accept(indexPath.row)
    collectionView.reloadData()
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
