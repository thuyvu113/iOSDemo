//
//  UserInfo.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-01.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

class Session {
  static let shared = Session()
  
  var userInfo: User?
  var genres: [String: Genre] = [:]
  var genresList: [Genre] = []
  var locationsList: [Location] = []
  
  func updateUserInfo(_ user: User) {
    userInfo = user
  }
  
  func updateGenres(_ genres: [Genre]) {
    genresList.append(Genre(id: "0", genre: "All"))
    genresList.append(contentsOf: genres)
    for genre in genres {
      self.genres[genre.id] = genre
    }
  }
  
  func updateLocations(_ locations: [Location]) {
    locationsList.append(contentsOf: locations)
  }
  
  func getGenreById(_ id: String) -> Genre? {
    return genres[id]
  }
}
