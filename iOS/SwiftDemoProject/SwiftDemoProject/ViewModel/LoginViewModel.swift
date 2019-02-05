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

class LoginViewModel {
  private let disposeBag = DisposeBag()
  private let service = APIService()
  
  var email = BehaviorRelay<String>(value: "")
  var password = BehaviorRelay<String>(value: "")
  var loginBtnTaped = PublishRelay<Void>()
  var loginInProgress = BehaviorRelay<Bool>(value: false)
  var loginSucessful = PublishRelay<Bool>()
  
  init() {
    loginBtnTaped.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.attemptToLogin()
    }).disposed(by: disposeBag)
  }
  
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
  
  private func attemptToLogin() {
    self.loginSucessful.accept(true)
      
//    loginInProgress.accept(true)
//    print("attempt to login")
//
//    service.login(email: email.value, password: password.value.toMD5())
//      .subscribe(onNext: {[weak self] user in
//        guard let self = self else { return }
//
//        Session.shared().updateUserInfo(user)
//
//        self.loginInProgress.accept(false)
//        self.loginSucessful.accept(true)
//      }, onError: {[weak self] error in
//        guard let self = self else { return }
//
//        print("Login error: \(error)")
//        self.loginInProgress.accept(false)
//        self.loginSucessful.accept(false)
//      }).disposed(by: disposeBag)
  }
}
