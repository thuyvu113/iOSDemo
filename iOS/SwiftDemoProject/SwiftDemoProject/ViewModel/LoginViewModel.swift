//
//  LoginViewModel.swift
//  SwiftDemoProject
//
<<<<<<< HEAD
//  Created by thuyvd on 2019-01-31.
=======
//  Created by thuyvd on 2019-01-28.
>>>>>>> login-screen
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
<<<<<<< HEAD
  
=======
  private let disposeBag = DisposeBag()
  
  var email = BehaviorRelay<String>(value: "")
  var password = BehaviorRelay<String>(value: "")
  var loginBtnTaped = PublishSubject<Void>()
  var loginInProgress = BehaviorRelay<Bool>(value: false)
  
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
    loginInProgress.accept(true)
    print("attempt to login")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
      self?.loginInProgress.accept(false)
    }
  }
>>>>>>> login-screen
}
