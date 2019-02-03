//
//  UserInfo.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-01.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

class UserInfo {
  static private var sharedInstance: UserInfo?
  
  class func shared() -> UserInfo {
    if let sharedInstance = UserInfo.sharedInstance {
      return sharedInstance
    }
    
    sharedInstance = UserInfo()
    return sharedInstance!
  }
  
  private var info: User?
  
  func updateUserInfo(_ user: User) {
    info = user
  }
  
  func getInfo() -> User {
    return info!
  }
  
}
