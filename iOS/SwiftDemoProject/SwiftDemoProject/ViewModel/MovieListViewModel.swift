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
  private var movies: [String: [Movie]] = [:]
  
  var curGenre: Genre?
  var loadingGenreInProgress = BehaviorRelay<Bool>(value: false)
  var loadingMovieInProgress = BehaviorRelay<Bool>(value: false)
  var requestMovieSuccessful = PublishRelay<Void>()
  var requestGenresSucessfull = PublishRelay<Void>()
  
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
    curGenre = genre
    getMovieByGenre(genre.id)
  }
  
  func didSelecedRowAtIndex(_ index: Int) {
    selectedRowIndex = index
  }
}

//MARK: API Service
extension MovieListViewModel {
  func getAllGenres() {
    loadingGenreInProgress.accept(true)
    
    service.getAllGenres().subscribe(onNext: { [weak self] genres in
      guard let self = self else { return }
      Session.shared.updateGenres(genres)
      self.genres = Session.shared.genresList
      self.requestGenresSucessfull.accept(())
      self.loadingGenreInProgress.accept(false)
      }, onError: { error in
        self.loadingGenreInProgress.accept(false)
    }).disposed(by: disposeBag)
  }
  
  func getMovieByGenre(_ genreId: String) {
    loadingMovieInProgress.accept(true)
    
    service.getMovies(genre: genreId).subscribe(onNext: {[weak self] movies in
      guard let self = self else { return }
      self.movies[genreId] = movies
      self.requestMovieSuccessful.accept(())
      self.loadingMovieInProgress.accept(false)
      }, onError: { error in
        
        self.loadingMovieInProgress.accept(false)
    }).disposed(by: disposeBag)
  }
}
