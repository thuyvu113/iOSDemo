//
//  CheckOutViewController.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckOutViewController: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: CheckOutViewModel!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var popcornNaviBar: PopcornNavigationBar!
  @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var baseView: UIView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieInfoLabel: UILabel!
  @IBOutlet weak var movieIMDBLabel: UILabel!
  @IBOutlet weak var leftPunchedHole: UIView!
  @IBOutlet weak var rightPunchedHole: UIView!
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var beginTimeLabel: UILabel!
  @IBOutlet weak var endTimeLabel: UILabel!
  @IBOutlet weak var seatsLabel: UILabel!
  @IBOutlet weak var seatNumberLabel: UILabel!
  @IBOutlet weak var ticketIDLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    binding()
  }
  
  func binding() {
    viewModel.movieTitle.asObservable().bind(to: movieTitleLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieInfo.asObservable().bind(to: movieInfoLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieIMDB.asObservable().bind(to: movieIMDBLabel.rx.text).disposed(by: disposeBag)
    viewModel.moviePoster.asObservable().bind(to: posterImageView.rx.image).disposed(by: disposeBag)
    viewModel.movieLocation.asObservable().bind(to: locationLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieDate.asObservable().bind(to: dateTimeLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieBegin.asObservable().bind(to: beginTimeLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieEnd.asObservable().bind(to: endTimeLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieSeats.asObservable().bind(to: seatsLabel.rx.text).disposed(by: disposeBag)
    viewModel.movieSeatNumber.asObservable().bind(to: seatNumberLabel.rx.text).disposed(by: disposeBag)
    viewModel.ticketID.asObservable().bind(to: ticketIDLabel.rx.text).disposed(by: disposeBag)
    viewModel.ticketPrice.asObservable().bind(to: priceLabel.rx.text).disposed(by: disposeBag)
    
    popcornNaviBar.backBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return}
      self.navigationController?.popViewController(animated: true)
    }.disposed(by: disposeBag)
    
    viewModel.loadData()
  }
  
  
  func setup() {
    popcornNaviBar.hideSettingsBtn()
    contentViewWidthConstraint.constant = UIScreen.screenWidth()
    scrollView.backgroundColor = UIColor(RGBA: [241, 241, 241, 100])
    baseView.layer.cornerRadius = 10
    posterImageView.layer.cornerRadius = 10
    leftPunchedHole.layer.cornerRadius = 12.5
    rightPunchedHole.layer.cornerRadius = 12.5
  }
  
  @IBAction func checkoutBtnDidTap(_ sender: Any) {
    viewModel.finishedCheckout.accept(())
    self.navigationController?.popViewController(animated: true)
  }
}
