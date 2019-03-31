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
  //show, hide loading indicator when waiting to request genres and locations
  var loadingInfoInProgress = PublishRelay<Bool>()
  //request movie in progress
  var loadingMovieInProgress = PublishRelay<Bool>()
  //publish movie, infomation result status
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
  
  //when user selected genre from genre tab bar
  func selectedGenre(_ genre: Genre) {
    resetSelection()
    curGenre = genre
    getMovieByGenre(genre.id)
  }
  
  //when user selected a movie to expand it
  func didSelecedRowAtIndex(_ index: Int) {
    selectedRowIndex = index
  }
  
  //Reset all movie selection
  func resetSelection() {
    Session.shared().selectedMovie = nil
    Session.shared().selectedDateIndex = nil
    Session.shared().selectedLocationIndex = nil
    Session.shared().selectedTimeIndex = nil
    selectedRowIndex = -1
  }
  
  func refreshCurrentGenre() {
    resetSelection()
    getMovieByGenre(curGenre!.id)
  }
}

//MARK: API Service
extension MovieListViewModel {
  //Get genres and location before get movies
  //This function will wait untill both information are requested
  //It is successful only when both genres and locations are requested sucessfully
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
      if let movies = movies {
        self.movies[genreId] = movies
      }
      self.requestMovieSuccessful.accept(())
      self.loadingMovieInProgress.accept(false)
      }).disposed(by: disposeBag)
  }
}
