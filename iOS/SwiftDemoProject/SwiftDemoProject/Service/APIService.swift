//
//  APIService.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class APIService {
  
  enum APIResponseError: Int, Error {
    case requestFailed = 1
    case parseFailed = 2
    case notFound = 404
  }
  
  func getMovies(genre genreId: String) -> Observable<[Movie]> {
    return Observable.create({ observer -> Disposable in
      let url = "https://iosdemono1.firebaseapp.com/movies?genre=\(genreId)"
      Alamofire.request(url)
        .validate()
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onError(response.error ?? APIResponseError.notFound)
              return
            }
            do {
              let responseData = try JSONDecoder().decode(ServerResponse.self, from: data)
              if responseData.status == 1 {
                let movies = responseData.data.get() as! [Movie]
                observer.onNext(movies)
              } else {
                observer.onError(APIResponseError.requestFailed)
              }
            } catch {
              observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
        })
      
      return Disposables.create()
    })
  }
  
  func getAllGenres() -> Observable<[Genre]> {
    return Observable.create({ observer -> Disposable in
      let url = "https://iosdemono1.firebaseapp.com/genres"
      Alamofire.request(url)
        .validate()
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onError(response.error ?? APIResponseError.notFound)
              return
            }
            do {
              let responseData = try JSONDecoder().decode(ServerResponse.self, from: data)
              if responseData.status == 1 {
                let genres = responseData.data.get() as! [Genre]
                observer.onNext(genres)
              } else {
                observer.onError(APIResponseError.requestFailed)
              }
            } catch {
              observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
        })
      
      return Disposables.create()
    })
  }
  
  func login(email: String, password: String) -> Observable<User> {
    let params = [
      "email": email,
      "password": password
    ]
    
    return Observable.create({ observer-> Disposable in
      let url = "https://iosdemono1.firebaseapp.com/login"
      Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
        .validate()
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onError(response.error ?? APIResponseError.notFound)
              return
            }
            do {
              try self.printResponse(data)
              let responseData = try JSONDecoder().decode(ServerResponse.self, from: data)
              if responseData.status == 1 {
                let userInfo = responseData.data.get() as! User
                observer.onNext(userInfo)
              } else {
                observer.onError(APIResponseError.requestFailed)
              }
            } catch {
              observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
        })
      return Disposables.create()
    })
  }
  
  private func printResponse(_ reponse: Data) throws {
    let object = try JSONSerialization.jsonObject(with: reponse, options: [])
    print(object)
  }
}
