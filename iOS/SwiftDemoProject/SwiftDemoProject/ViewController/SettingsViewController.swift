//
//  SettingsViewController.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-06.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class SettingsViewController: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: SettingsViewModel!
  
  @IBOutlet weak var popcornNaviBar: PopcornNavigationBar!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    viewModel.loadData()
    bindViewModel()
  }
  
  func setup() {
    popcornNaviBar.hideSettingsBtn()
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  func bindViewModel() {
    viewModel.touchIDLoginDidChange.asObservable().subscribe(onNext: { [weak self] isOn in
      guard let self = self else { return }
      self.showTouchIDLoginChangeAlert(isOn: isOn)
    }).disposed(by: disposeBag)
    
    viewModel.checkPasswordInProgress.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      self.showLoadingProgress(show: event.element!)
    }.disposed(by: disposeBag)
    
    viewModel.passwordCorrect.asObservable().subscribe(onNext: { [weak self] isCorrect in
      guard let self = self else { return }
      self.showSavePasswordResult(isCorrect: isCorrect)
    }).disposed(by: disposeBag)
    
    viewModel.savePasswordSucessful.asObservable().subscribe(onNext: { [weak self] success in
      guard let self = self else { return }
      if success == false {
        self.savePasswordFailed()
      }
    }).disposed(by: disposeBag)
  }
  
  func showTouchIDLoginChangeAlert(isOn: Bool) {
    if isOn {
      let alertView = UIAlertController(title: "Touch ID",
                                        message: "Please enter current password",
                                        preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "Enable", style: .default, handler: { _ in
        if let password = alertView.textFields?[0].text {
          self.viewModel.savePassword(password)
        }
      }))
      
      alertView.addTextField { textField in
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
      }
      self.navigationController?.present(alertView, animated: true, completion: nil)
    } else {
      let alertView = UIAlertController(title: "Disable Touch ID",
                                        message: "Are you sure you want to disable Touch ID Login?",
                                        preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      alertView.addAction(UIAlertAction(title: "Disable", style: .default, handler: { _ in
        self.viewModel.deletePassword()
      }))
      self.navigationController?.present(alertView, animated: true, completion: nil)
    }
  }
  
  func showLoadingProgress(show: Bool) {
    if show {
      HUD.show(.progress)
    } else {
      HUD.hide()
    }
  }
  
  func showSavePasswordResult(isCorrect: Bool) {
    if isCorrect {
      HUD.flash(.success)
    } else {
      let alertView = UIAlertController(title: "Password Incortect",
                                        message: "Please check your password again.",
                                        preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.navigationController?.present(alertView, animated: true, completion: nil)
    }
  }
  
  func savePasswordFailed() {
    let alertView = UIAlertController(title: "Error",
                                      message: "Touch ID can not be saved now!",
                                      preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.navigationController?.present(alertView, animated: true, completion: nil)
  }
}

extension SettingsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath)
      let fullNameLabel = cell.viewWithTag(11) as! UILabel
      let emailLabel = cell.viewWithTag(12) as! UILabel
      viewModel.fullName.asObservable().bind(to: fullNameLabel.rx.text).disposed(by: disposeBag)
      viewModel.email.asObservable().bind(to: emailLabel.rx.text).disposed(by: disposeBag)
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "touchIDCell", for: indexPath)
    let switchBtn = cell.viewWithTag(21) as! UISwitch
    switchBtn.rx.isOn.changed.asObservable().distinctUntilChanged()
      .bind(to: viewModel.touchIDLoginDidChange).disposed(by: disposeBag)
    viewModel.touchIDLogin.asObservable().bind(to: switchBtn.rx.isOn).disposed(by: disposeBag)
    viewModel.touchIDEnabled.asObservable().bind(to: switchBtn.rx.isEnabled).disposed(by: disposeBag)
    return cell
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 82
    }
    
    return 50
  }
}
