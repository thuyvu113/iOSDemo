//
//  CheckOutViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-06.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckOutViewModel {
  private let disposeBag = DisposeBag()
  private var ticket: Ticket!
  
  var finishedCheckout = PublishRelay<Void>()
  
  var movieTitle = BehaviorRelay<String>(value: "")
  var movieInfo = BehaviorRelay<String>(value: "")
  var movieIMDB = BehaviorRelay<String>(value: "")
  var moviePoster = BehaviorRelay<UIImage?>(value: nil)
  var movieLocation = BehaviorRelay<String>(value: "")
  var movieDate = BehaviorRelay<String>(value: "")
  var movieBegin = BehaviorRelay<String>(value: "")
  var movieEnd = BehaviorRelay<String>(value: "")
  var movieAudi = BehaviorRelay<String>(value: "")
  var movieSeats = BehaviorRelay<String>(value: "")
  var movieSeatNumber = BehaviorRelay<String>(value: "")
  var ticketID = BehaviorRelay<String>(value: "")
  var ticketPrice = BehaviorRelay<String>(value: "")
    
  required init(ticket: Ticket) {
    self.ticket = ticket
  }
  
  func loadData() {
    let movie = ticket.movie!
    
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
    
    movieLocation.accept(ticket.location.name)
    let dateString = "\(ticket.date.weekdayName()), \(ticket.date.day) \(ticket.date.monthName())"
    movieDate.accept(dateString)
    
    let begin = ticket.location.showTimes[ticket.timeIndex]
    movieBegin.accept(begin)
    
    movieEnd.accept(Helper.movieEndTime(beginTime: begin, duration: movie.duration))
    
    movieSeats.accept(ticket.seats.joined(separator: ", "))
    movieSeatNumber.accept("Seats (\(ticket.seats.count))")
    
    ticketID.accept(ticket.id)
    ticketPrice.accept(String(format: "$ %0.2f", ticket.getTotalPrice()))
  }
}
