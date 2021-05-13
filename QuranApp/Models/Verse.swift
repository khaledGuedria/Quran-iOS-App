//
//  Verse.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/11/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import Foundation

class Verse: Decodable {
    
    var content: String

    enum CodingKeys: String, CodingKey {
        case content = "verse_0"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)

    }

}

