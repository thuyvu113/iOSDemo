//
//  LoginViewModelTests.swift
//  SwiftDemoProjectTests
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import XCTest
import RxSwift

@testable import SwiftDemoProject

class LoginViewModelTests: XCTestCase {
  var viewModel: LoginViewModel!
  var disposeBag: DisposeBag!
  
  override func setUp() {
    viewModel = LoginViewModel()
    disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    viewModel = nil
    disposeBag = nil
  }
  
  func testCredentialsValid_1() {
    viewModel.email.accept("example@gmail.com")
    viewModel.password.accept("123456")
    viewModel.credentialsValid.subscribe(onNext: { isValid in
      XCTAssertTrue(isValid)
    }).disposed(by: disposeBag)
  }
  
  func testCredentialsInValid_1() {
    viewModel.email.accept("example@gmail.c")
    viewModel.password.accept("123456")
    viewModel.credentialsValid.subscribe(onNext: { isValid in
      XCTAssertFalse(isValid)
    }).disposed(by: disposeBag)
  }
  
  func testCredentialsInValid_2() {
    viewModel.email.accept("example@gmail.com")
    viewModel.password.accept("1234")
    viewModel.credentialsValid.subscribe(onNext: { isValid in
      XCTAssertFalse(isValid)
    }).disposed(by: disposeBag)
  }
  
  func testLoginSucessfully() {
    viewModel.email.accept("example@abc.com")
    viewModel.password.accept("123456")
    
    let promise = expectation(description: "Login successfully")
    viewModel.loginSucessful.asObservable().subscribe(onNext: {
      XCTAssertTrue($0)
      XCTAssertNotNil(Session.shared().userInfo)
      promise.fulfill()
    }).disposed(by: disposeBag)
    
    viewModel.loginBtnTaped.accept(())
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testLoginFailed() {
    viewModel.email.accept("example@abc.com")
    viewModel.password.accept("1234567")
    
    let promise = expectation(description: "Login failed")
    viewModel.loginSucessful.asObservable().subscribe(onNext: {
      XCTAssertFalse($0)
      XCTAssertNil(Session.shared().userInfo)
      promise.fulfill()
    }).disposed(by: disposeBag)
    
    viewModel.loginBtnTaped.accept(())
    
    waitForExpectations(timeout: 5, handler: nil)
  }

}
