//
//  Ticket.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-05.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Ticket {
  let movie: Movie
  var location: String?
  var date: Date?
  var time: Double?
  var seats: [String] = []
  var audi: String?
  
  func getTotalPrice() -> Double {
    return Double(seats.count) * 10.99
  }
}
