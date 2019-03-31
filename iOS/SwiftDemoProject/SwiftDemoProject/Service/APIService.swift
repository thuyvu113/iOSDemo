//
//  APIService.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
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
  func getMovies(genre genreId: String) -> Observable<[Movie]?> {
    return Observable.create({ observer -> Disposable in
      let provider = MoyaProvider<APITarget>()
      provider.rx.request(.movies(genreId: genreId)).subscribe{ event in
        switch event {
        case .success(let response):
          do {
            let movies = try response.map(APIResponse<[Movie]>.self).data
            observer.onNext(movies)
          } catch {
            observer.onNext(nil)
          }
        case .error:
          observer.onNext(nil)
        }
      }.disposed(by: self.disposeBag)
      
      return Disposables.create()
    })
  }
  
  //Get all locations, cinemas
  //Return and observable value
  //It is required to process onNext event only with optional location list
  func getAllLocations() -> Observable<[Location]?> {
    return Observable.create({ observer -> Disposable in
      let provider = MoyaProvider<APITarget>()
      provider.rx.request(.locations).subscribe { event in
        switch event {
        case .success(let response):
          do {
            let locations = try response.map(APIResponse<[Location]>.self).data
            observer.onNext(locations)
          } catch {
            observer.onNext(nil)
          }
        case .error:
          observer.onNext(nil)
        }
      }.disposed(by: self.disposeBag)
      
      return Disposables.create()
    })
  }
  
  //Get all genres
  //Return and observable value
  //It is required to process onNext event only with optional genre list
  func getAllGenres() -> Observable<[Genre]?> {
    return Observable.create({ observer -> Disposable in
      let provider = MoyaProvider<APITarget>()
      provider.rx.request(.genres).subscribe{ event in
        switch event {
        case .success(let response):
          do {
            let genres = try response.map(APIResponse<[Genre]>.self).data
            observer.onNext(genres)
          } catch {
            observer.onNext(nil)
          }
        case .error:
          observer.onNext(nil)
        }
      }.disposed(by: self.disposeBag)
      
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
            if let userInfo = try response.map(APIResponse<User>.self).data {
              observer.onNext(userInfo)
            } else {
              observer.onError(APIResponseError.notFound)
            }
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
}
