//
//  Ticket.swift
//  SwiftDemoProject
//
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Ticket {
  var id = "PVR 4930 AYUSH 6721"
  let movie: Movie!
  var location: Location!
  var date: CalendarDay!
  var timeIndex: Int = -1
  var seats: [String] = []
  var audi: String = "04"
  
  init(movie: Movie) {
    self.movie = movie
  }
  
  func getTotalPrice() -> Double {
    return Double(seats.count) * 10.99
  }
  
  func getMovieDateTimeString() -> String {
    return "\(date.day) \(date.monthName()) - \(location.showTimes[timeIndex])"
  }

}
