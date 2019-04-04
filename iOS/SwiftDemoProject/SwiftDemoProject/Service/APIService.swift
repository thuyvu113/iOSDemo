//
//  APIService.swift
//  SwiftDemoProject
//
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
      case .success(let responseData):
        do {
          let response = try responseData.map(APIResponse<[Movie]>.self)
          if response.status == 1, let movies = response.data {
            result.accept(movies)
          } else {
            result.accept(nil)
          }
        } catch {
          result.accept(nil)
        }
      case .error:
        result.accept(nil)
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
      case .success(let responseData):
        do {
          let response = try responseData.map(APIResponse<[Location]>.self)
          if response.status == 1, let locations = response.data {
            result.accept(locations)
          } else {
            result.accept(nil)
          }
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
      case .success(let responseData):
        do {
          let response = try responseData.map(APIResponse<[Genre]>.self)
          if response.status == 1, let genres = response.data {
            result.accept(genres)
          } else {
            result.accept(nil)
          }
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
      case .success(let responseData):
        do {
          let response = try responseData.map(APIResponse<User>.self)
          if  response.status == 1, let userInfo = response.data {
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
