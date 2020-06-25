//
//  Genre.swift
//  Filmescoop
//
//  Created by Danilo Pena on 21/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

struct Genre: Codable {
    let id: Int?
    let name: String?
    
    func toGenreRealm() -> GenreRealm {
        let genreRealm = GenreRealm()
        genreRealm.id = self.id ?? 0
        genreRealm.name = self.name
        
        return genreRealm
    }
}
