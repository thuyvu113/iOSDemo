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
  
  var viewModel = LoginViewModel()
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    setupViews()
    
    viewModel.email.accept("example@abc.com")
    viewModel.password.accept("123456")
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
  }
  
  @objc func hideKeyboard() {
    emailTF.resignFirstResponder()
    passwordTF.resignFirstResponder()
  }
  
  func showLoadingProgress(show: Bool) {
    if show {
      HUD.show(.progress)
    } else {
      HUD.hide()
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
    loginBtn.rx.tap.asObservable().bind(to: viewModel.loginBtnTaped).disposed(by: disposeBag)
    
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
  }
  
}

//MARK: Login results
extension LoginViewController {
  func handleLoginResults(success: Bool) {
    if success {
      self.performSegue(withIdentifier: "toMovieList", sender: self)
    } else {
      let alertPopup = UIAlertController(title: "Login Failed",
                                         message: "Please check your email and password",
                                         preferredStyle: .alert)
      alertPopup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertPopup, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMovieList",
      let destination = segue.destination as? MovieListViewController {
      let viewModel = MovieListViewModel()
      destination.viewModel = viewModel
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
