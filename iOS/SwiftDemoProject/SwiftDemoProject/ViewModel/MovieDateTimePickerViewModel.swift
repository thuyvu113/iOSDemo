//
//  MovieTimePickerViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-04.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//Model for day in date selection section in each cell
struct CalendarDay {
  let month: Int
  let day: Int
  let weekday: Int
  
  init(month: Int, day: Int, weekday: Int) {
    self.month = month
    self.day = day
    self.weekday = weekday
  }
  
  func monthName() -> String {
    return DateFormatter().monthSymbols[month - 1]
  }
  
  func weekdayFirstLetter() -> String {
    let weekdayName = self.weekdayName()
    return String(weekdayName.first!)
  }
  
  func weekdayName() -> String {
    return DateFormatter().weekdaySymbols[weekday - 1]
  }
}

class MovieDateTimePickerViewModel {
  var locations: [Location]!
  
  var seclectedTimeIndex = BehaviorRelay<Int>(value: -1)
  var selectedLocationIndex = BehaviorRelay<Int>(value: 0)
  var selectedDateIndex = BehaviorRelay<Int>(value: 0)
  
  //Only enable seat selection button when user chose date, location, time for a movie
  var selectedEnoughInfo: Observable<Bool> {
    return Observable.combineLatest(selectedDateIndex.asObservable(),
                                    selectedLocationIndex.asObservable(),
                                    seclectedTimeIndex.asObservable()) {($0 >= 0) && ($1 >= 0) && ($2 >= 0)}
  }
  
  //List of dates to chose, one week from the current day
  var dates: [CalendarDay]!
  
  init() {
    dates = self.getSevenDays()
    locations = Session.shared().locationsList
  }
  
  //Load data for the current expanded movie cell
  func preLoadDataFromSession() {
    if let dateIndex = Session.shared().selectedDateIndex {
      selectedDateIndex.accept(dateIndex)
    }
    
    if let locationIndex = Session.shared().selectedLocationIndex {
      selectedLocationIndex.accept(locationIndex)
    }
    
    if let timeIndex = Session.shared().selectedTimeIndex {
      seclectedTimeIndex.accept(timeIndex)
    }
  }
  
  //reset for collapsed cell
  func reset() {
    seclectedTimeIndex.accept(-1)
    selectedDateIndex.accept(0)
    selectedLocationIndex.accept(0)
  }
  
  private func getSevenDays() -> [CalendarDay] {
    var sevenDays: [CalendarDay] = []
    let today = Date.init()
    for i in 0...7 {
      let nextDate = Calendar.current.date(byAdding: .day, value: i, to: today)
      let month = Calendar.current.component(.month, from: nextDate!)
      let day = Calendar.current.component(.day, from: nextDate!)
      let weekday = Calendar.current.component(.weekday, from: nextDate!)
      sevenDays.append(CalendarDay(month: month, day: day, weekday: weekday))
    }
    return sevenDays
  }
  
  func getNumberOfShowTimes() -> Int{
    if let locations = self.locations {
      return locations[selectedLocationIndex.value].showTimes.count
    }
    
    return 0
  }
  
  func getLocationName() -> String {
    if let locations = self.locations {
      return locations[selectedLocationIndex.value].name
    }
    
    return ""
  }
  
  func getShowTimeString(atIndex: Int) -> String {
    if let locations = self.locations {
      let showTimes = locations[selectedLocationIndex.value].showTimes
      return showTimes[atIndex]
    }
    
    return ""
  }
  
  func getSelectedLocation() -> Location? {
    if selectedLocationIndex.value >= 0 {
      return locations[selectedLocationIndex.value]
    }
    
    return nil
  }
  
  func getSelectedDate() -> CalendarDay? {
    if selectedDateIndex.value >= 0 {
      return dates[selectedDateIndex.value]
    }
    
    return nil
  }
}
