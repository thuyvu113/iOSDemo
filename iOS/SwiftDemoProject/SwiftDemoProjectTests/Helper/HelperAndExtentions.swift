//
//  Helper.swift
//  SwiftDemoProjectTests
//
//  Created by thuyvd on 2019-04-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import XCTest

@testable import SwiftDemoProject

class HelperAndExtensions: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testStringMD5Extention() {
    let md5 = "123456".toMD5()
    let expectMD5 = "e10adc3949ba59abbe56e057f20f883e"
    
    XCTAssertEqual(md5, expectMD5);
  }
  
  func testConvertDurationToStringWithMinute() {
    let duration = 90
    let durationString = "1h 30m"
    
    XCTAssertEqual(Helper.convertDurationToString(duration), durationString)
  }
  
  func testConvertDurationToString() {
    let duration = 120
    let durationString = "2h"
    
    XCTAssertEqual(Helper.convertDurationToString(duration), durationString)
  }
  
  func testTimeComponents_testCase1() {
    let timeString = "1:30 PM"
    XCTAssertEqual(Helper.timeComponents(input: timeString), ["1", "30", "PM"])
  }
  
  func testTimeComponents_testCase2() {
    let timeString = "01:9 AM"
    XCTAssertEqual(Helper.timeComponents(input: timeString), ["01", "9", "AM"])
  }
  
  func testTimeComponents_testCase3() {
    let timeString = "01:40 AM"
    XCTAssertEqual(Helper.timeComponents(input: timeString), ["01", "40", "AM"])
  }

  func testTimeComponents_testCase4() {
    let timeString = "01:40 am"
    XCTAssertNil(Helper.timeComponents(input: timeString))
  }
  
  func testTimeComponents_testCase5() {
    let timeString = "01:403 PM"
    XCTAssertNil(Helper.timeComponents(input: timeString))
  }
  
  func testMovieEndTime_testCase1() {
    let begin = "7:30 AM"
    let duration = 60
    
    XCTAssertEqual(Helper.movieEndTime(beginTime: begin, duration: duration), "8:30 AM")
  }
  
  func testMovieEndTime_testCase2() {
    let begin = "7:30 AM"
    let duration = -60
    
    XCTAssertEqual(Helper.movieEndTime(beginTime: begin, duration: duration), "")
  }
  
  func testMovieEndTime_testCase3() {
    let begin = "4:30 PM"
    let duration = 120
    
    XCTAssertEqual(Helper.movieEndTime(beginTime: begin, duration: duration), "6:30 PM")
  }
}
