//
//  LoginViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-28.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication

class LoginViewModel {
  private let disposeBag = DisposeBag()
  private let service = APIService()
  
  var email = BehaviorRelay<String>(value: "")
  var password = BehaviorRelay<String>(value: "")
  //Listen to login button tap action
  var loginBtnTaped = PublishRelay<Void>()
  //To show, hide loading indicator (PKHUD)
  var loginInProgress = PublishRelay<Bool>()
  //Listen to result of login request
  var loginSucessful = PublishRelay<Bool>()
  //Listen to touhc ID button action
  var touchIdBtnTaped = PublishRelay<Void>()
  //Listen to failed case of touch ID to show email, password text fields
  var loginByTouchIDFailed = PublishRelay<Void>()
  
  init() {
    //Login when login button taped
    loginBtnTaped.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.attemptToLogin()
    }).disposed(by: disposeBag)
    
    //Active touch ID to retrive saved password and login
    touchIdBtnTaped.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.loginWithTouchId()
    }).disposed(by: disposeBag)
  }
  
  //Combine two observable variables in one
  //Check if both email and password are valid
  var credentialsValid: Observable<Bool> {
    return Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
  }
  
  private var emailValid: Observable<Bool> {
    return email.asObservable().map({ value -> Bool in
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      
      let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailTest.evaluate(with: value)
    })
  }
  
  private var passwordValid: Observable<Bool> {
    return password.asObservable().map{ $0.count >= 6}
  }
  
  private func loginWithTouchId() {
    LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please provide your fingerprint to login") { (success, error) in
      if success {
        do {
          let keychainService = KeychainService()
          let password = try keychainService.getPassword(forUser: Helper.getSavedUserId())
          self.password.accept(password)
          self.attemptToLogin()
        } catch {
          self.loginByTouchIDFailed.accept(())
        }
      } else {
        self.loginByTouchIDFailed.accept(())
      }
    }
  }
  
  private func attemptToLogin() {      
    loginInProgress.accept(true)
    print("attempt to login")

    service.login(email: email.value, password: password.value.toMD5())
      .subscribe(onNext: {[weak self] user in
        guard let self = self else { return }

        Session.shared().updateUserInfo(user)

        self.loginInProgress.accept(false)
        self.loginSucessful.accept(true)
      }, onError: {[weak self] error in
        guard let self = self else { return }

        print("Login error: \(error)")
        self.loginInProgress.accept(false)
        self.loginSucessful.accept(false)
      }).disposed(by: disposeBag)
  }
}
