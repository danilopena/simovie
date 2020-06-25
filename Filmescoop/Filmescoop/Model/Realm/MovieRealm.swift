//
//  MovieRealm.swift
//  Filmescoop
//
//  Created by Danilo Pena on 24/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import RealmSwift
import Foundation

final class GenreRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toGenre() -> Genre {
        return Genre(id: self.id, name: self.name)
    }
}

 final class MovieRealm: Object {
    @objc dynamic var popularity:       Double = 0.0
    @objc dynamic var voteCount:        Int = 0
    @objc dynamic var video:            Bool = false
    @objc dynamic var posterPath:       String?
    @objc dynamic var id:               Int32 = 0
    @objc dynamic var adult  = false
    @objc dynamic var backdropPath:     String?
    @objc dynamic var originalLanguage: String?
    @objc dynamic var originalTitle:    String?
    let genres = List<GenreRealm>()
    @objc dynamic var title:            String?
    @objc dynamic var voteAverage:      Double = 0.0
    @objc dynamic var overview:         String?
    @objc dynamic var releaseDate:      String?
    @objc dynamic var budget:           Double = 0.0
    @objc dynamic var homepage:         String?
    @objc dynamic var imdbId:           String?
    @objc dynamic var revenue:          Double = 0.0
    @objc dynamic var runtime:          Int = 0
    @objc dynamic var status:           String?
    @objc dynamic var tagline:          String?
    
    class func getMoviesFromRealm () -> [Movie]? {
        if let realm = try? Realm() {
            var arrayMovies = [Movie]()
            Array(realm.objects(MovieRealm.self)).forEach { (movieRealm) in
                arrayMovies.append(movieRealm.toMovie())
            }
            return arrayMovies
        }
        return nil
    }
    
    class func getMovieFromRealm (with id: Int32) -> Movie? {
        if let realm = try? Realm() {
            return realm.object(ofType: MovieRealm.self, forPrimaryKey: id)?.toMovie()
        }
        return nil
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toMovie() -> Movie {
        return Movie(popularity: self.popularity,
                     voteCount: self.voteCount,
                     video: self.video,
                     posterPath: self.posterPath,
                     id: self.id,
                     adult: self.adult,
                     backdropPath: self.backdropPath,
                     originalLanguage: self.originalLanguage,
                     originalTitle: self.originalTitle,
                     genres: nil,
                     title: self.title,
                     voteAverage: self.voteAverage,
                     overview: self.overview,
                     releaseDate: self.releaseDate,
                     budget: self.budget,
                     homepage: self.homepage,
                     imdbId: self.imdbId,
                     revenue: self.revenue,
                     runtime: self.runtime,
                     status: self.status,
                     tagline: self.tagline
        )
    }
}
