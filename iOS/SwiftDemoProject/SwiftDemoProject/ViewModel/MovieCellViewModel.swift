//
//  MovieCellViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-03.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieCellViewModel {
  private let disposeBag = DisposeBag()
  
  var movie = BehaviorRelay<Movie?>(value: nil)
  
  var movieTitle = BehaviorRelay<String>(value: "")
  var movieInfo = BehaviorRelay<String>(value: "")
  var movieIMDB = BehaviorRelay<String>(value: "")
  var moviePoster = BehaviorRelay<UIImage?>(value: nil)
  
  init() {
    movie.asObservable().subscribe(onNext: { [weak self] movie in
      guard let self = self else { return }
      if let movie = movie {
        self.updateMovie(movie)
      }
    }).disposed(by: disposeBag)
  }
  
  private func updateMovie(_ movie: Movie) {
    movieTitle.accept(movie.title)
    var info = ""
    for genreId in movie.genres {
      let genre = Session.shared.getGenreById(genreId)
      if genreId == movie.genres.last {
        info += "\(genre?.genre ?? "")"
      } else {
        info += "\(genre?.genre ?? "") | "
      }
    }
    
    info += " - \(convertDurationToString(movie.duration))"
    movieInfo.accept(info)
    
    let imdb = String(format: "%.01f", movie.imdb)
    movieIMDB.accept(imdb)
    
    ImageCache.shared.loadImage(url: movie.poster).subscribe(onNext: { [weak self] image in
      guard let self = self else { return }
      self.moviePoster.accept(image)
    }, onError: { error in
      
    }).disposed(by: disposeBag)
  }
  
  func convertDurationToString(_ duration: Int) -> String {
    let hours = duration / 60
    let minutes = duration - hours * 60
    if minutes > 0 {
      return "\(hours)h \(minutes)m"
    }
    
    return "\(hours)h"
  }
}
