//
//  StringExtension.swift
//  SwiftDemoProject
//
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
  func toMD5() -> String {
    let messageData = self.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
      messageData.withUnsafeBytes {messageBytes in
        CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
      }
    }
    
    return digestData.map{String(format: "%02hhx", $0)}.joined()
  }
}
