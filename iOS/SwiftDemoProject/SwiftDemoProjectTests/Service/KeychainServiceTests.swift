//
//  KeychainServiceTests.swift
//  SwiftDemoProjectTests
//
//  Created by thuyvd on 2019-02-07.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import XCTest

@testable import SwiftDemoProject

class KeychainServiceTests: XCTestCase {
  var keychainService: KeychainService!

  override func setUp() {
    keychainService = KeychainService()
  }
  
  override func tearDown() {
    keychainService = nil
  }
  
  func testSavePassword() {
    let password = "123456"
    let userId = "1242311"
    
    do  {
      try keychainService.savePassword(password, forUser: userId)
    } catch {
      print(error)
      XCTFail()
    }
  }
  
  func testGetPassword() {
    let password = "123456"
    let userId = "1242311"
    do {
      let savedPassword = try keychainService.getPassword(forUser: userId)
      XCTAssertEqual(password, savedPassword)
    } catch {
      print(error)
      XCTFail()
    }
  }
  
  func testDeletePassword() {
    let userId = "1242311"
    do {
      try keychainService.deletePassword(forUser: userId)
    } catch {
      print(error)
      XCTFail()
    }
  }
  
}
