//
//  APITarget.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-03-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import Moya

public enum APITarget {
  case login(email: String, password: String)
  case movies(genreId: String)
  case locations
  case genres
}

extension APITarget: TargetType {
  public var baseURL: URL {
    return URL(string: "https://iosdemono1.firebaseapp.com")!
  }
  
  public var path: String {
    switch self {
    case .login: return "/login"
    case .movies(let genreId): return "/movies?genre=\(genreId)"
    case .genres: return "/genres"
    case .locations: return "/locations"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .login: return .post
    case .movies, .genres, .locations: return .get
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .login(let email, let password):
      let params = [
        "email": email,
        "password": password
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    case .movies, .genres, .locations:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
  public var validationType: ValidationType {
    return .successCodes
  }
}
