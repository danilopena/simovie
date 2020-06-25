//
//  Movie.swift
//  Filmescoop
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

struct Movie: Codable {
    let popularity:       Double?
    let voteCount:        Int?
    let video:            Bool?
    let posterPath:       String?
    let id:               Int32?
    let adult:            Bool?
    let backdropPath:     String?
    let originalLanguage: String?
    let originalTitle:    String?
    let genres:           [Genre]?
    let title:            String?
    let voteAverage:      Double?
    let overview:         String?
    let releaseDate:      String?
    let budget:           Double?
    let homepage:         String?
    let imdbId:           String?
    let revenue:          Double?
    let runtime:          Int?
    let status:           String?
    let tagline:          String?
    
    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genres
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case budget
        case homepage
        case imdbId = "imdb_id"
        case revenue
        case runtime
        case status
        case tagline
    }
        
    func toMovieRealm() -> MovieRealm {
        let movieRealm = MovieRealm()
        movieRealm.popularity = self.popularity ?? 0.0
        movieRealm.voteCount = self.voteCount ?? 0
        movieRealm.video = self.video ?? false
        movieRealm.posterPath = self.posterPath
        movieRealm.id = self.id ?? 0
        movieRealm.adult = self.adult ?? false
        movieRealm.backdropPath = self.backdropPath
        movieRealm.originalLanguage = self.originalLanguage
        movieRealm.originalTitle = self.originalTitle
        
        self.genres?.forEach({ (genre) in
            movieRealm.genres.append(genre.toGenreRealm())
        })
        
        movieRealm.title = self.title
        movieRealm.voteAverage = self.voteAverage ?? 0.0
        movieRealm.overview = self.overview
        movieRealm.releaseDate = self.releaseDate
        movieRealm.budget = self.budget ?? 0.0
        movieRealm.homepage = self.homepage
        movieRealm.imdbId = self.imdbId
        movieRealm.revenue = self.revenue ?? 0.0
        movieRealm.runtime = self.runtime ?? 0
        movieRealm.status = self.status
        movieRealm.tagline = self.tagline
        
        return movieRealm
    }
}
