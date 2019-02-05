//
//  MovieTableViewCell.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieTableViewCellDelegate: class {
  func seatChoosingDidSeclected(sender: UIButton)
}

class MovieTableViewCell: UITableViewCell {
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var topBaseView: UIView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieInfoLabel: UILabel!
  @IBOutlet weak var movieIMDBLabel: UILabel!
  
  @IBOutlet weak var leftPunchedHole: UIView!
  @IBOutlet weak var rightPunchedHole: UIView!
  @IBOutlet weak var nextBtn: UIButton!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var movieDateTimePickerView: MovieDateTimePicker!
  
  var viewModel: MovieCellViewModel?
  weak var delegate: MovieTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    self.layer.masksToBounds = true
    
    topBaseView.layer.cornerRadius = 10
    posterImageView.layer.cornerRadius = 10
    leftPunchedHole.layer.cornerRadius = 12.5
    rightPunchedHole.layer.cornerRadius = 12.5
    
    nextBtn.layer.addShadow(color: UIColor(RGBA: [229, 57, 53, 31]), x: 0, y: 6, blur: 15)
    nextBtn.rx.tap.asObservable().subscribe { [weak self] __ in
      guard let self = self else { return }
      self.delegate?.seatChoosingDidSeclected(sender: self.nextBtn)
    }.disposed(by: disposeBag)
  }
  
  func updateMovie(_ movie: Movie, expanded: Bool = false) {
    if viewModel == nil {
      viewModel = MovieCellViewModel()
      bindViewModel()
    }
    
    viewModel?.movie.accept(movie)
    
    if expanded {
      bottomConstraint.constant = 40
      nextBtn.isHidden = false
    } else {
      bottomConstraint.constant = 20
      nextBtn.isHidden = true
    }
    layoutIfNeeded()
    movieDateTimePickerView.reloadLayoutIfNeeded()
  }
  
  func bindViewModel() {
    viewModel?.movieTitle.asObservable().bind(to: movieTitleLabel.rx.text).disposed(by: disposeBag)
    viewModel?.movieInfo.asObservable().bind(to: movieInfoLabel.rx.text).disposed(by: disposeBag)
    viewModel?.movieIMDB.asObservable().bind(to: movieIMDBLabel.rx.text).disposed(by: disposeBag)
    viewModel?.moviePoster.asObservable().bind(to: posterImageView.rx.image).disposed(by: disposeBag)
  }
}
