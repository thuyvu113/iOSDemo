//
//  Genre.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Genre: Decodable {
  let id: String
  let genre: String
  
  init(id: String, genre: String) {
    self.id = id
    self.genre = genre
  }
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

extension Genre: PopcornTabBarItem {
  func getTitle() -> String {
    return genre
  }
}
