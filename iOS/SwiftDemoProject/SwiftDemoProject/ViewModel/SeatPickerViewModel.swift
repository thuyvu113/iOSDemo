//
//  SeatPickerViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-05.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SeatPickerViewModel {
  var ticket = BehaviorRelay<Ticket?>(value: nil)
  var movieTitle = BehaviorRelay<String>(value: "")
  var movieLocation = BehaviorRelay<String>(value: "")
  var movieDateTime = BehaviorRelay<String>(value: "")
}
