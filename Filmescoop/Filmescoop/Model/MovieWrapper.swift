//
//  MovieWrapper.swift
//  Filmescoop
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

struct MovieWrapper: Codable {
    let page:         Int?
    let totalResults: Int32?
    let totalPages:   Int32?
    let results:      [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
