//
//  APITarget.swift
//  SwiftDemoProject
//
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
    case .movies: return "/movies"
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
    switch self {
    case .login(let email, _):
      let json = """
      {
      \"status\": 1,
      \"data\": {
        \"id\": \"123123\",
        \"email\": \"\(email)\",
        \"firstname\": \"thuy\",
        \"lastname\": \"vu\"
      }
      }
      """
      return json.data(using: .utf8)!
    case .movies:
      let json = """
      {
      \"status\": 1,
      \"data\": [
      {
        \"id\": \"16\",
        \"title\": \"Mirai\",
        \"duration\": 120,
        \"imdb\": 7.2,
        \"genres\": [\"1\", \"5\"],
        \"poster\": \"https://firebasestorage.googleapis.com/v0/b/iosdemono1.appspot.com/o/poster_01_tfp39627.jpg?alt=media\",
        \"cover\": \"https://firebasestorage.googleapis.com/v0/b/iosdemono1.appspot.com/o/bg_01_nkp39896.jpg?alt=media\"
      }
      ]
      }
      """
      return json.data(using: .utf8)!
    case .genres:
      let json = """
      {
      \"status\": 1,
      \"data\":[
      {
        \"id\": \"1\",
        \"genre\": \"Drama\"
      }
      ]
      }
      """
      return json.data(using: .utf8)!
    case .locations:
      let json = """
      {
      \"status\": 1,
      \"data\":[
      {
        \"id\": \"1\",
        \"name\": \"Scotiabank Theatre Toronto\",
        \"showTimes\": [\"10:30 AM\", \"1:00 PM\", \"2:00 PM\", \"7:30 PM\"]
      }
      ]
      }
      """
      return json.data(using: .utf8)!
    }
  }
  
  public var task: Task {
    switch self {
    case .login(let email, let password):
      let params = [
        "email": email,
        "password": password
      ]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    case .movies(let genreId):
      return .requestParameters(parameters: ["genre": genreId], encoding: URLEncoding.default)
    case .genres, .locations:
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
