//
//  Surah.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/9/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import Foundation

class Surah: Decodable {

    var index: String
    var titleAr: String
    var count: Int

    enum CodingKeys: String, CodingKey {
        case index
        case titleAr
        case count
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(String.self, forKey: .index)
        self.titleAr = try container.decode(String.self, forKey: .titleAr)
        self.count = try container.decode(Int.self, forKey: .count)
    }

}

struct Surahs: Decodable {
  let count: Int
  let all: [Surah]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "juz"
  }
}
