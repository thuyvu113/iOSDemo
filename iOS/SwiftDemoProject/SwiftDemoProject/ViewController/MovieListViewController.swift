//
//  MovieListViewController.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class MovieListViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  var cellHeights: [IndexPath: CGFloat] = [:]
  var viewModel: MovieListViewModel?
  
  @IBOutlet weak var popcornNaviBar: PopcornNavigationBar!
  @IBOutlet weak var tabBarView: PopcornTabBarView!
  @IBOutlet weak var tableView: UITableView!
  
  var seatPickerView: SeatPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    popcornNaviBar.hideBackBtn()
    bindViewModel()
    setup()
    viewModel?.getRequiredInfo()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func setup() {
    tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "movieCell")
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    tableView.estimatedRowHeight = 0
    
    seatPickerView = (Bundle.main.loadNibNamed("SeatPickerView", owner: self, options: nil)?[0] as! SeatPickerView)
    seatPickerView.delegate = self
  }
  
  func showLoadingProgress(show: Bool) {
    if show {
      HUD.show(.progress)
    } else {
      HUD.hide()
    }
  }
  
  func updateGenresTabBar() {
    let genres = Session.shared().genresList
    tabBarView.buildTab(items: genres)
  }
  
  func didFinishCheckout() {
    viewModel?.resetSelection()
    tableView.reloadData()
  }
}

//MARK: Binding
extension MovieListViewController {
  func bindViewModel() {
    viewModel?.requestMovieSuccessful.asObservable().subscribe({ [weak self] _ in
      guard let self = self else { return }
      self.tableView.reloadData()
    }).disposed(by: disposeBag)
    
    viewModel?.loadingInfoInProgress.asObservable().subscribe({ [weak self] event in
      guard let self = self else { return }
      self.showLoadingProgress(show: event.element!)
    }).disposed(by: disposeBag)
    
    viewModel?.requestInfoSucessfull.asObservable().subscribe({ [weak self] event in
      guard let self = self else { return }
      if event.element! {
        self.updateGenresTabBar()
      }
    }).disposed(by: disposeBag)
    
    tabBarView.selectedGenre.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      if let genre = event.element! {
         self.viewModel?.selectedGenre(genre)
      }
    }.disposed(by: disposeBag)
    
    popcornNaviBar.settingsBtn.rx.tap.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let settingsVC = (storyboard.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController)
      settingsVC.viewModel = SettingsViewModel()
      self.navigationController?.pushViewController(settingsVC, animated: true)
    }.disposed(by: disposeBag)
  }
}

//MARK: Seat picker delegate
extension MovieListViewController: SeatPickerViewDelegate {
  func checkoutTicket(_ ticket: Ticket) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let checkoutVC = (storyboard.instantiateViewController(withIdentifier: "checkoutVC") as! CheckOutViewController)
    checkoutVC.viewModel = CheckOutViewModel(ticket: ticket)
    checkoutVC.viewModel.finishedCheckout.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.didFinishCheckout()
    }.disposed(by: disposeBag)
    self.navigationController?.pushViewController(checkoutVC, animated: true)
  }
}

//MARK: Movie Cell Delegate
extension MovieListViewController: MovieTableViewCellDelegate {
  func seatChoosingDidSeclected(sender: UIButton, ticket: Ticket) {
    seatPickerView.viewModel.updateTicket(ticket: ticket)

    let fromRect = sender.superview?.convert(sender.frame, to: view)
    seatPickerView.frame = view.bounds
    view.addSubview(seatPickerView)
    seatPickerView.showView(fromRect: fromRect!)
  }
  
}

//MARK: Table datasource
extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.getNumberOfMovie() ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
    cell.delegate = self
    let movie = viewModel?.getMovieAt(indexPath.row)
    let expanded = viewModel?.selectedRowIndex == indexPath.row
    cell.updateMovie(movie!, expanded: expanded)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == viewModel?.selectedRowIndex {
      return 432
    }
    
    return 158
  }
}

//MARK: Table delegate
extension MovieListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let prevSelectedRow = viewModel?.selectedRowIndex ?? -1

    var list = [indexPath]
    var selectedRow = -1
    if prevSelectedRow >= 0 {
      if prevSelectedRow != indexPath.row {
        let oldIndexPath = IndexPath(row: prevSelectedRow, section: 0)
        list.append(oldIndexPath)
        selectedRow = indexPath.row
      } else {
        selectedRow = -1
      }
    } else {
      selectedRow = indexPath.row
    }

    viewModel?.didSelecedRowAtIndex(selectedRow)
    tableView.reloadRows(at: list, with: UITableView.RowAnimation.automatic)
    if selectedRow >= 0 {
      tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
  }
}
