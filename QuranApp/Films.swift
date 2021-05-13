//
//  Films.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/9/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import Foundation

struct Films: Decodable {
  let count: Int
  let all: [Film]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
