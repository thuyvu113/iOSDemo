//
//  Movie.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct Movie: Decodable {
  let id: String
  let title: String
  let duration: Int
  let imdb: Float
  let genres: [String]
  let poster: String
  let cover: String
}

extension Movie: CustomStringConvertible {
  var description: String {
    return """
    {
      id: \(id)
      title: \(title)
      duration: \(duration)
      imdb: \(imdb)
      genres: \(genres)
      poster: \(poster)
      cover: \(cover)
    }
    """
  }
}
