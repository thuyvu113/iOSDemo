//
//  Helper.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-06.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import LocalAuthentication

class Helper {
  static func convertDurationToString(_ duration: Int) -> String {
    let hours = duration / 60
    let minutes = duration - hours * 60
    if minutes > 0 {
      return "\(hours)h \(minutes)m"
    }
    
    return "\(hours)h"
  }

  static func movieEndTime(beginTime: String, duration: Int) -> String {
    if let components = timeComponents(input: beginTime) {
      let tag = components[2]
      var hours = Int(components[0])!
      hours = tag == "PM" ? (hours + 12) : hours
      let minutes = Int(components[1])!
      
      let durationHours = duration / 60
      let durationMinutes = duration - durationHours * 60
      
      var endHours = hours + durationHours
      var endMinutes = minutes + durationMinutes
      if endMinutes >= 60 {
        endHours += 1
        endMinutes -= 60
      }
      
      if endHours > 12 {
        return "\(endHours - 12):\(endMinutes) PM"
      } else {
        return "\(endHours):\(endMinutes) AM"
      }
    }
    
    return ""
  }
  
  static func timeComponents(input: String) -> [String]?{
    let regex = try! NSRegularExpression(pattern: "([0-9]{1,2}):([0-9]{1,2})\\s+(AM|PM)")
    let range = NSRange(location: 0, length: input.utf16.count)
    if let firstMatch = regex.firstMatch(in: input, options: [], range: range) {
      var output = [String]()
      for i in 1...3 {
        if let matchedRange = Range(firstMatch.range(at: i), in: input) {
          output.append(String(input[matchedRange]))
        } else {
          return nil
        }
      }
      return output
    }
    
    return nil
  }

  static func isTouchIDEnabled() -> Bool {
    if #available(iOS 8.0, *) {
      return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    return false
  }
  
  static func getSavedUser() -> String? {
    return UserDefaults.standard.string(forKey: "saveUserEmail")
  }
  
  static func getSavedUserId() -> String {
    return UserDefaults.standard.string(forKey: "saveUserId")!
  }
  
  static func saveUser() {
    UserDefaults.standard.set(Session.shared().userInfo?.email, forKey: "saveUserEmail")
    UserDefaults.standard.set(Session.shared().userInfo?.id, forKey: "saveUserId")
    UserDefaults.standard.synchronize()
  }

  static func deleteSavedUser() {
    UserDefaults.standard.removeObject(forKey: "savedUserEmail")
    UserDefaults.standard.removeObject(forKey: "savedUserId")
    UserDefaults.standard.synchronize()
  }
}
