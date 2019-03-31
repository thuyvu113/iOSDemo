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
import Moya

class APIService {
  let disposeBag = DisposeBag()
  
  enum APIResponseError: Int, Error {
    case requestFailed = 1
    case parseFailed = 2
    case notFound = 404
  }
  
  //Get movies by genre
  //Return an observable value
  //It is required to catch both onNext and onError events
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
  
  //Get all locations, cinemas
  //Return and observable value
  //It is required to process onNext event only with optional location list
  func getAllLocations() -> Observable<[Location]?> {
    return Observable.create({ observer -> Disposable in
      let url = "https://iosdemono1.firebaseapp.com/locations"
      Alamofire.request(url)
        .validate()
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onNext(nil)
              return
            }
            do {
              let responseData = try JSONDecoder().decode(ServerResponse.self, from: data)
              if responseData.status == 1 {
                let locations = responseData.data.get() as! [Location]
                observer.onNext(locations)
              } else {
                observer.onNext(nil)
              }
            } catch {
              observer.onNext(nil)
            }
          case .failure:
            observer.onNext(nil)
          }
        })
      
      return Disposables.create()
    })
  }
  
  //Get all genres
  //Return and observable value
  //It is required to process onNext event only with optional genre list
  func getAllGenres() -> Observable<[Genre]?> {
    return Observable.create({ observer -> Disposable in
      let url = "https://iosdemono1.firebaseapp.com/genres"
      Alamofire.request(url)
        .validate()
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onNext(nil)
              return
            }
            do {
              let responseData = try JSONDecoder().decode(ServerResponse.self, from: data)
              if responseData.status == 1 {
                let genres = responseData.data.get() as! [Genre]
                observer.onNext(genres)
              } else {
                observer.onNext(nil)
              }
            } catch {
              observer.onNext(nil)
            }
          case .failure:
            observer.onNext(nil)
          }
        })
      
      return Disposables.create()
    })
  }
  
  //Login by email and password
  //Password parameter is MD5 hash
  //It is required to process both onNext and onError events
  func login(email: String, password: String) -> Observable<User> {
    return Observable.create({observer-> Disposable in
      let provider = MoyaProvider<APITarget>()
      provider.rx.request(.login(email: email, password: password)).subscribe { event in
        switch event {
        case .success(let response):
          do {
            let userInfo = try response.map(APIResponse<User>.self).data
            observer.onNext(userInfo)
          } catch {
            observer.onError(APIResponseError.parseFailed)
          }
        case .error(let error):
          observer.onError(error)
        }
      }.disposed(by: self.disposeBag)
      
      return Disposables.create()
    })
  }
  
  private func printResponse(_ reponse: Data) throws {
    let object = try JSONSerialization.jsonObject(with: reponse, options: [])
    print(object)
  }
}
