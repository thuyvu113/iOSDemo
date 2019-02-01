//
//  User.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-01-31.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

struct User: Decodable {
  let id: String
  let email: String
  let firstName: String
  let lastName: String
  
  private enum CodingKeys: String, CodingKey {
    case id
    case email
    case firstName = "firstname"
    case lastName = "lastname"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    email = try container.decode(String.self, forKey: .email)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
  }
}

extension User: CustomStringConvertible {
  var description: String {
    return """
    {
      id: \(id)
      email: \(email)
      firstName: \(firstName)
      lastName: \(lastName)
    }
    """
  }
}
