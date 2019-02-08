//
//  MovieListViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel {
  private let disposeBag = DisposeBag()
  private let service = APIService()
  
  var genres: [Genre] = []
  var locations: [Location] = []
  private var movies: [String: [Movie]] = [:]
  
  var curGenre: Genre?
  var loadingInfoInProgress = BehaviorRelay<Bool>(value: false)
  var loadingMovieInProgress = BehaviorRelay<Bool>(value: false)
  var requestMovieSuccessful = PublishRelay<Void>()
  var requestInfoSucessfull = PublishRelay<Bool>()
  
  var selectedRowIndex = -1;
  
  func getNumberOfMovie() -> Int {
    if let genre = curGenre, let allMovies = movies[genre.id] {
        return allMovies.count
    }
    
    return 0
  }
  
  func getMovieAt(_ index: Int) -> Movie? {
    if let genre = curGenre, let allMovies = movies[genre.id] {
      return allMovies[index]
    }
    
    return nil
  }
  
  func selectedGenre(_ genre: Genre) {
    resetSelection()
    curGenre = genre
    getMovieByGenre(genre.id)
  }
  
  func didSelecedRowAtIndex(_ index: Int) {
    selectedRowIndex = index
  }
  
  func resetSelection() {
    Session.shared().selectedMovie = nil
    Session.shared().selectedDateIndex = nil
    Session.shared().selectedLocationIndex = nil
    Session.shared().selectedTimeIndex = nil
    selectedRowIndex = -1
  }
}

//MARK: API Service
extension MovieListViewModel {
  func getRequiredInfo() {
    loadingInfoInProgress.accept(true)

    let genreInfo = service.getAllGenres()
    let locationInfo = service.getAllLocations()
    
    Observable.zip(genreInfo, locationInfo) { ($0, $1) }.subscribe(onNext: { [weak self] result in
      guard let self = self else { return }
      if let genres = result.0, let locations = result.1 {
        Session.shared().updateGenres(genres)
        Session.shared().updateLocations(locations)
        self.genres = genres
        self.locations = locations
        self.requestInfoSucessfull.accept(true)
      } else {
        self.requestInfoSucessfull.accept(false)
      }
      
      self.loadingInfoInProgress.accept(false)
    }).disposed(by: disposeBag)
  }

  
  func getMovieByGenre(_ genreId: String) {
    loadingMovieInProgress.accept(true)
    
    service.getMovies(genre: genreId).subscribe(onNext: {[weak self] movies in
      guard let self = self else { return }
      self.movies[genreId] = movies
      self.requestMovieSuccessful.accept(())
      self.loadingMovieInProgress.accept(false)
      }, onError: { _ in
        self.loadingMovieInProgress.accept(false)
    }).disposed(by: disposeBag)
  }
}
