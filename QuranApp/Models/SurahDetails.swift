//
//  SurahDetails.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/11/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import Foundation

class SurahDetails: Decodable {

    var index: String
    var count: Int
    var verses: [String : String]

    enum CodingKeys: String, CodingKey {
        case index
        case count
        case verse
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(String.self, forKey: .index)
        self.count = try container.decode(Int.self, forKey: .count)
        self.verses = try container.decode([String : String].self, forKey: .verse)
    }

}



