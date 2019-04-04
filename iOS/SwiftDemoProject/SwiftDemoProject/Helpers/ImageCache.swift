//
//  ImageCache.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

enum ImageCacheError: Int, Error {
  case convertDataToImageError = 1
}

class ImageCache {
  private static let sharedInstance = ImageCache()
  
  class func shared() -> ImageCache {
    return sharedInstance
  }
  
  var cachedImages: [String: UIImage] = [:]
  
  init() {
    NotificationCenter
      .default
      .addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                   object: nil, queue: .main) { [weak self] _ in
                    guard let self = self else {return}
                    self.clearCached()
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func loadImage(url: String) -> Observable<UIImage> {
    let key = url.toMD5()
    return Observable.create({ [weak self] observer -> Disposable in
      guard let self = self else { return Disposables.create() }
      
      if let image = self.cachedImages[key] {
        observer.onNext(image)
      } else {
        Alamofire.request(url).validate().responseData(completionHandler: { response in
          switch response.result {
          case .success:
            if let image = UIImage(data: response.data!)  {
              self.set(image: image, forKey: key)
              observer.onNext(image)
            } else {
              observer.onError(ImageCacheError.convertDataToImageError)
            }
          case .failure(let error):
            observer.onError(error)
            print("Load Image Error: \(error)")
          }
        })
      }
      
      return Disposables.create()
    })
  }
  
  func clearCached() {
    cachedImages.removeAll()
  }
  
  func set(image: UIImage, forKey key: String) {
    cachedImages[key] = image
  }
}
