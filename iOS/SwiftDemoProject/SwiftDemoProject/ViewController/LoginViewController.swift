//
//  LoginViewController.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-28.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import PKHUD

class LoginViewController: UIViewController {
  
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  
  @IBOutlet weak var emailBox: UIView!
  @IBOutlet weak var passwordBox: UIView!
  @IBOutlet weak var touchIDBox: UIView!
  @IBOutlet weak var touchIDBtn: UIButton!
  
  var viewModel = LoginViewModel()
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    setupViews()
  }
  
  func setupViews() {
    loginBtn.layer.masksToBounds = false
    loginBtn.layer.addShadow(color: UIColor.init(RGBA: [229, 57, 53, 31]), x: 0, y: 8, blur: 30)
    
    let touchGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(touchGesture)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
    
    touchIDBox.layer.cornerRadius = 10
    touchIDBox.layer.borderWidth = 1
    touchIDBox.layer.borderColor = UIColor.init(RGBA: [229, 57, 53, 100]).cgColor
    
    if let email = Helper.getSavedUser() {
      loginBtn.isHidden = true
      passwordBox.isHidden = true
      viewModel.email.accept(email)
    } else {
      touchIDBox.isHidden = true
      viewModel.email.accept("example@abc.com")
      viewModel.password.accept("123456")
    }
  }
  
  @objc func hideKeyboard() {
    emailTF.resignFirstResponder()
    passwordTF.resignFirstResponder()
  }
  
  func showLoadingProgress(show: Bool) {
    if show {
      DispatchQueue.main.async {
        HUD.show(.progress)
      }
    } else {
      DispatchQueue.main.async {
        HUD.hide()
      }
    }
  }
  
  func hideTouchID() {
    DispatchQueue.main.async {
      self.loginBtn.isHidden = false
      self.passwordBox.isHidden = false
      self.touchIDBox.isHidden = true
    }
  }
}

//MARK: ViewModel
extension LoginViewController {
  func bindViewModel() {
    emailTF.rx.text.unwrap().bind(to: viewModel.email).disposed(by: disposeBag)
    viewModel.email.asObservable().bind(to: emailTF.rx.text).disposed(by: disposeBag)
    passwordTF.rx.text.unwrap().bind(to: viewModel.password).disposed(by: disposeBag)
    viewModel.password.asObservable().bind(to: passwordTF.rx.text).disposed(by: disposeBag)
    
    viewModel.credentialsValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    loginBtn.rx.tap
      .debounce(1.0, scheduler: MainScheduler.instance).asObservable()
      .bind(to: viewModel.loginBtnTaped).disposed(by: disposeBag)
    touchIDBtn.rx.tap
      .debounce(1.0, scheduler: MainScheduler.instance).asObservable()
      .bind(to: viewModel.touchIdBtnTaped).disposed(by: disposeBag)
    
    viewModel.loginBtnTaped.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.hideKeyboard()
    }).disposed(by: disposeBag)
    
    viewModel.loginInProgress.asObservable().distinctUntilChanged().subscribe { [weak self] event in
      guard let self = self else { return }
      self.showLoadingProgress(show: event.element!)
    }.disposed(by: disposeBag)
    
    viewModel.loginSucessful.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      self.handleLoginResults(success: event.element!)
    }.disposed(by: disposeBag)
    
    viewModel.loginByTouchIDFailed.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.hideTouchID()
    }
  }
  
}

//MARK: Login results
extension LoginViewController {
  func handleLoginResults(success: Bool) {
    if success {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let movieListVC = (storyboard.instantiateViewController(withIdentifier: "movieListVC") as! MovieListViewController)
      movieListVC.viewModel = MovieListViewModel()
      self.navigationController?.pushViewController(movieListVC, animated: true)
      
    } else {
      let alertPopup = UIAlertController(title: "Login Failed",
                                         message: "Please check your email and password",
                                         preferredStyle: .alert)
      alertPopup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertPopup, animated: true, completion: nil)
    }
  }
}
//MARK: Keyboard
extension LoginViewController {
  @objc func keyboardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let offset = loginView.frame.maxY - (UIScreen.screenHeight() - keyboardSize.height) + 10
      view.frame.origin.y -= offset
    }
  }
  
  @objc func keyboardWillHide(notification: Notification) {
    view.frame.origin.y = 0
  }
}
