//
//  LoginViewController.swift
//  SwiftDemoProject
//
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
  
  @IBOutlet weak var logoView: UIStackView!
  @IBOutlet weak var logoViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoViewCenterYConstraint: NSLayoutConstraint!
  
  var viewModel = LoginViewModel()
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
      self.logoViewCenterYConstraint.isActive = false

      self.logoViewBottomConstraint.isActive = true
      self.logoViewTopConstraint.isActive = true
      self.view.layoutIfNeeded()
    }) { _ in
      UIView.animate(withDuration: 0.3, animations: {
        self.loginView.alpha = 1
      })
    }
  }
  
  func setupViews() {
    loginBtn.layer.masksToBounds = false
    loginBtn.layer.addShadow(color: UIColor.init(RGBA: [229, 57, 53, 31]), x: 0, y: 8, blur: 30)
    
    let touchGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(touchGesture)
    
    touchIDBox.layer.cornerRadius = 10
    touchIDBox.layer.borderWidth = 1
    touchIDBox.layer.borderColor = UIColor.init(RGBA: [229, 57, 53, 100]).cgColor
    
    if let email = Helper.getSavedUser(), Helper.isTouchIDEnabled() {
      loginBtn.isHidden = true
      passwordBox.isHidden = true
      viewModel.email.accept(email)
    } else {
      touchIDBox.isHidden = true
      viewModel.email.accept("example@abc.com")
      viewModel.password.accept("123456")
    }
    
    loginView.alpha = 0
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
      .debounce(0.4, scheduler: MainScheduler.instance).asObservable()
      .bind(to: viewModel.loginBtnTaped).disposed(by: disposeBag)
    
    touchIDBtn.rx.tap
      .debounce(0.4, scheduler: MainScheduler.instance).asObservable()
      .bind(to: viewModel.touchIdBtnTaped).disposed(by: disposeBag)
    
    loginBtn.rx.tap.subscribe(onNext: { [weak self] in
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
    }.disposed(by: disposeBag)
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
