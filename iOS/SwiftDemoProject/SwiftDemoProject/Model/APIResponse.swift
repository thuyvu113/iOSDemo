//
//  APIResponse.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
  let status: Int
  let data: T?
}
