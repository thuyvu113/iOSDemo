//
//  ServerResponse.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct ServerResponse: Decodable {
  let status: Int
  let data: ReponseData
}

enum ReponseData: Decodable {
  case null(), user(User), genres([Genre]), movies([Movie])
  
  enum DataServerError: Error {
    case unknownType
  }
  
  init(from decoder: Decoder) throws {
    if let user = try? decoder.singleValueContainer().decode(User.self) {
      self = .user(user)
      return
    } else {
      try? print(decoder.singleValueContainer().decode(User.self))
    }
    
    if let movies = try? decoder.singleValueContainer().decode([Movie].self) {
      self = .movies(movies)
      return
    }
    
    if let genres = try? decoder.singleValueContainer().decode([Genre].self) {
      self = .genres(genres)
      return
    }
    
    self = .null()
  }
  
  func get() -> Any? {
    switch self {
    case .user(let user):
      return user
    case .movies(let movies):
      return movies
    case .genres(let genres):
      return genres
    default:
      return nil
    }
  }
}
