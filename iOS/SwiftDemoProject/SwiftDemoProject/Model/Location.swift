//
//  Location.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-05.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Location: Decodable {
  let id: String
  let name: String
  let showTimes: [String]
}
