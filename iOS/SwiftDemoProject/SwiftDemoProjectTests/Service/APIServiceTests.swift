//
//  APIServiceTests.swift
//  SwiftDemoProjectTests
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import XCTest
import RxSwift

@testable import SwiftDemoProject

class APIServiceTests: XCTestCase {
  var service: APIService!
  var disposeBag: DisposeBag!
  
  override func setUp() {
    super.setUp()
    disposeBag = DisposeBag()
    service = APIService()
  }
  
  override func tearDown() {
    service = nil
    disposeBag = nil
    super.tearDown()
  }
  
  func testGetMovies() {
    let genreId = "5"
    
    let promise = expectation(description: "Get movies successfuly")
    
    service.getMovies(genre: genreId).subscribe(onNext: { movies in
      promise.fulfill()
    }, onError: { error in
      XCTFail("Error: \(error)")
    }).disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGetAllGenres() {
    let promise = expectation(description: "Get genres successfuly")
    
    service.getAllGenres().subscribe(onNext: { genres in
      promise.fulfill()
    }, onError: { error in
      XCTFail("Error: \(error)")
    }).disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGetAllLocations() {
    let promise = expectation(description: "Get locations successfuly")
    
    service.getAllLocations().subscribe(onNext: { locations in
      promise.fulfill()
    }, onError: { error in
      XCTFail("Error: \(error)")
    }).disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }

  
  func testLoginFailed() {
    let email = "example@abc.com"
    let password = "1231".toMD5()
    let promise = expectation(description: "Login Failed")
    
    service.login(email: email, password: password).subscribe(onNext: { user in
       XCTFail("Login should failed")
    }, onError: { error in
      promise.fulfill()
    }).disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testLoginSuccessfully() {
    let email = "example@abc.com"
    let password = "123456".toMD5()
    
    let promise = expectation(description: "Login successfuly")
    
    service.login(email: email, password: password).subscribe(onNext: { user in
      promise.fulfill()
    }, onError: { error in
      XCTFail("Error: \(error)")
    }).disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
}
