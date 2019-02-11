//
//  SettingsViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-06.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication

class SettingsViewModel {
  private let disposeBag = DisposeBag()
  
  var service = APIService()
  var fullName = BehaviorRelay<String>(value: "")
  var email = BehaviorRelay<String>(value: "")
  var touchIDLogin = BehaviorRelay<Bool>(value: false)
  var touchIDEnabled = BehaviorRelay<Bool>(value: false)
  var touchIDLoginDidChange = PublishRelay<Bool>()
  
  var checkPasswordInProgress = PublishRelay<Bool>()
  var passwordCorrect = PublishRelay<Bool>()
  var savePasswordSucessful = PublishRelay<Bool>()
  
  func loadData() {
    if let user = Session.shared().userInfo {
      fullName.accept("\(user.firstName) \(user.lastName)")
      email.accept(user.email)
    }
    
    if Helper.isTouchIDEnabled() {
      touchIDEnabled.accept(true)
      do {
        let keychainService = KeychainService()
        try _ = keychainService.getPassword(forUser: (Session.shared().userInfo?.id)!)
        touchIDLogin.accept(true)
      } catch {}
    }
  }
  
  //check password before save to keychain
  func savePassword(_ password: String) {
    self.checkPasswordInProgress.accept(true)
    let email = (Session.shared().userInfo?.email)!
    
    service.login(email: email, password: password.toMD5())
      .subscribe(onNext: {[weak self] user in
        guard let self = self else { return }
        self.savePasswordToKeychain(password)
        self.checkPasswordInProgress.accept(false)
        self.passwordCorrect.accept(true)
        }, onError: {[weak self] error in
          guard let self = self else { return }
          self.checkPasswordInProgress.accept(false)
          self.passwordCorrect.accept(false)
      }).disposed(by: disposeBag)
  }
  
  private func savePasswordToKeychain(_ password: String) {
    do {
      let keychainService = KeychainService()
      try keychainService.savePassword(password, forUser: (Session.shared().userInfo?.id)!)
      Helper.saveUser()
    } catch {
      savePasswordSucessful.accept(false)
    }
  }
  
  func deletePassword() {
    do {
      let keychainService = KeychainService()
      try keychainService.deletePassword(forUser: (Session.shared().userInfo?.id)!)
      Helper.deleteSavedUser()
    } catch {
      savePasswordSucessful.accept(false)
    }
  }
}
