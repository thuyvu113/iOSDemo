//
//  APIService.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
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
    let result = PublishRelay<[Movie]?>()
    
    let provider = MoyaProvider<APITarget>()
    provider.rx.request(.movies(genreId: genreId)).subscribe{ event in
      switch event {
      case .success(let response):
        do {
          let movies = try response.map(APIResponse<[Movie]>.self).data
          result.accept(movies)
        } catch {
          result.accept(nil)
        }
      case .error:
        result.acceptt(nil)
      }
      }.disposed(by: self.disposeBag)
    
    return result.asObservable()
  }
  
  //Get all locations, cinemas
  //Return and observable value
  //It is required to process onNext event only with optional location list
  func getAllLocations() -> Observable<[Location]?> {
    let result = PublishRelay<[Location]?>()
    
    let provider = MoyaProvider<APITarget>()
    provider.rx.request(.locations).subscribe { event in
      switch event {
      case .success(let response):
        do {
          let locations = try response.map(APIResponse<[Location]>.self).data
          result.accept(locations)
        } catch {
          result.accept(nil)
        }
      case .error:
        result.accept(nil)
      }
      }.disposed(by: self.disposeBag)
    
    return result.asObservable()
  }
  
  //Get all genres
  //Return and observable value
  //It is required to process onNext event only with optional genre list
  func getAllGenres() -> Observable<[Genre]?> {
    let result = PublishRelay<[Genre]?>()
    
    let provider = MoyaProvider<APITarget>()
    provider.rx.request(.genres).subscribe{ event in
      switch event {
      case .success(let response):
        do {
          let genres = try response.map(APIResponse<[Genre]>.self).data
          result.accept(genres)
        } catch {
          result.accept(nil)
        }
      case .error:
        result.accept(nil)
      }
      }.disposed(by: self.disposeBag)
    
    return result.asObservable()
  }
  
  //Login by email and password
  //Password parameter is MD5 hash
  //It is required to process both onNext and onError events
  func login(email: String, password: String) -> Observable<User> {
    let result = PublishSubject<User>()
    
    let provider = MoyaProvider<APITarget>()
    provider.rx.request(.login(email: email, password: password)).subscribe { event in
      switch event {
      case .success(let response):
        do {
          if let userInfo = try response.map(APIResponse<User>.self).data {
            result.onNext(userInfo)
          } else {
            result.onError(APIResponseError.notFound)
          }
        } catch {
          result.onError(APIResponseError.parseFailed)
        }
      case .error(let error):
        result.onError(error)
      }
      }.disposed(by: self.disposeBag)
    
    return result.asObservable()
  }
}
