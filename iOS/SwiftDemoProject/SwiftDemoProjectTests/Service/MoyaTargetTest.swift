//
//  MoyaTargetTest.swift
//  SwiftDemoProjectTests
//
//  Created by thuyvd on 2019-04-04.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import XCTest
import RxSwift
import Moya

@testable import SwiftDemoProject

class MoyaTargetTest: XCTestCase {
  var disposeBag: DisposeBag!
  
  override func setUp() {
    disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    disposeBag = nil
  }
  
  func testLoginAPI() {
    let promise = expectation(description: "Test Login API")
    
    let provider = MoyaProvider<APITarget>(stubClosure: MoyaProvider.immediatelyStub)
    provider.rx.request(.login(email: "example@abc.com", password: "12456"))
      .subscribe(onSuccess: { responseData in
        do {
          _ = try responseData.map(APIResponse<User>.self)
          promise.fulfill()
        } catch {
          XCTFail("Parse login reponse failed: \(error)")
        }
      }) { error in
        XCTFail("\(error)")
    }.disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGetAllGenres() {
    let promise = expectation(description: "Get All Genres")
    
    let provider = MoyaProvider<APITarget>(stubClosure: MoyaProvider.immediatelyStub)
    provider.rx.request(.genres).subscribe(onSuccess: { response in
      do {
        _ = try response.map(APIResponse<[Genre]>.self)
        promise.fulfill()
      } catch {
        XCTFail("Parse failed: \(error)")
      }
    }) { error in
      XCTFail("\(error)")
    }.disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGetAllLocations() {
    let promise = expectation(description: "Get All Loctions")
    
    let provider = MoyaProvider<APITarget>(stubClosure: MoyaProvider.immediatelyStub)
    provider.rx.request(.locations).subscribe(onSuccess: { response in
      do {
        _ = try response.map(APIResponse<[Location]>.self)
        promise.fulfill()
      } catch {
        XCTFail("Parse failed: \(error)")
      }
    }) { error in
      XCTFail("\(error)")
      }.disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }

  func testGetMovies() {
    let genreId = "1"
    let promise = expectation(description: "Get Movies")
    
    let provider = MoyaProvider<APITarget>(stubClosure: MoyaProvider.immediatelyStub)
    provider.rx.request(.movies(genreId: genreId)).subscribe(onSuccess: { response in
      do {
        _ = try response.map(APIResponse<[Movie]>.self)
        promise.fulfill()
      } catch {
        XCTFail("Parse failed: \(error)")
      }
    }) { error in
      XCTFail("\(error)")
      }.disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5, handler: nil)
  }

}
