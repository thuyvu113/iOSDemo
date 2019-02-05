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

struct CalendarDay {
  let day: String
  let weekday: String
  
  init(day: Int, weekday: Int) {
    self.day = "\(day)"
    self.weekday = CalendarDay.weekdayString(weekday)
  }
  
  static func weekdayString(_ day: Int) -> String {
    switch day {
    case 1, 7:
      return "S"
    case 2:
      return "M"
    case 3, 5:
      return "T"
    case 4:
      return "W"
    case 6:
      return "F"
    default:
      return ""
    }
  }
}

class MovieDateTimePickerViewModel {
  var locations: [Location]?
  
  init() {
    locations = Session.shared.locationsList
  }
  
  func getSevenDays() -> [CalendarDay] {
    var sevenDays: [CalendarDay] = []
    let today = Date.init()
    for i in 0...7 {
      let nextDate = Calendar.current.date(byAdding: .day, value: i, to: today)
      let day = Calendar.current.component(.day, from: nextDate!)
      let weekday = Calendar.current.component(.weekday, from: nextDate!)
      sevenDays.append(CalendarDay(day: day, weekday: weekday))
    }
    return sevenDays
  }
  
  func getNumberOfShowTimes(locationIndex: Int) -> Int{
    if let locations = self.locations {
      return locations[locationIndex].showTimes.count
    }
    
    return 0
  }
  
  func getLocationName(locationIndex: Int) -> String {
    if let locations = self.locations {
      return locations[locationIndex].name
    }
    
    return ""
  }
  
  func getShowTimeString(locationIndex: Int, showTimeIndex: Int) -> String {
    if let locations = self.locations {
      let showTimes = locations[locationIndex].showTimes
      for time in showTimes {
        Date(
      }
    }
    
    return ""
  }
}
