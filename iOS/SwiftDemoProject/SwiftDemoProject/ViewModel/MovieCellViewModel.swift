//
//  MovieCellViewModel.swift
//  SwiftDemoProject
//
//
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
  
  weak var dateTimePickerViewModel: MovieDateTimePickerViewModel!
  
  init() {
    movie.asObservable().subscribe(onNext: { [weak self] movie in
      guard let self = self else { return }
      if let movie = movie {
        self.updateMovie(movie)
      }
    }).disposed(by: disposeBag)
  }
  
  //Create ticket when user press seat selection button
  func createTicket() -> Ticket {
    var ticket = Ticket(movie: movie.value!)
    ticket.location = dateTimePickerViewModel.getSelectedLocation()
    ticket.date = dateTimePickerViewModel.getSelectedDate()
    ticket.timeIndex = dateTimePickerViewModel.seclectedTimeIndex.value
    return ticket
  }
  
  //Change movie model for each cell
  private func updateMovie(_ movie: Movie) {
    movieTitle.accept(movie.title)
    var info = ""
    for genreId in movie.genres {
      let genre = Session.shared().getGenreById(genreId)
      if genreId == movie.genres.last {
        info += "\(genre?.genre ?? "")"
      } else {
        info += "\(genre?.genre ?? "") | "
      }
    }
    
    info += " - \(Helper.convertDurationToString(movie.duration))"
    movieInfo.accept(info)
    
    let imdb = String(format: "%.01f", movie.imdb)
    movieIMDB.accept(imdb)
    
    self.moviePoster.accept(nil)
    ImageCache.shared().loadImage(url: movie.poster).subscribe(onNext: { [weak self] image in
      guard let self = self else { return }
      self.moviePoster.accept(image)
    }, onError: { error in
      
    }).disposed(by: disposeBag)
  }
}
