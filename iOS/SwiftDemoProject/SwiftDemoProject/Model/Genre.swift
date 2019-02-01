//
//  Genre.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Genre: Decodable {
  let id: String
  let genre: String
}

extension Genre: CustomStringConvertible {
  var description: String {
    return """
    {
      id: \(id)
      genre: \(genre)
    }
    """
  }
}
