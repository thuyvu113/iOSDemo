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
  
//  private enum CodingKeys: String, CodingKey {
//    case id, genre
//  }
//  
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    id = try container.decode(String.self, forKey: .id)
//    genre = try container.decode(String.self, forKey: .genre)
//  }
  
}
