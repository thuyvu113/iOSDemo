//
//  User.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct User: Decodable {
  let id: String
  let email: String
  let firstName: String
  let lastName: String
}
