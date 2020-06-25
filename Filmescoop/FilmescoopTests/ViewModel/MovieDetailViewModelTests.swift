//
//  MovieDetailViewModelTests.swift
//  FilmescoopTests
//
//  Created by Danilo Pena on 24/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import XCTest
@testable import SiMovie

final class MovieDetailViewModelTests: XCTestCase {

    private var movieDetailViewModel: MovieDetailViewModel!
        
    override func setUp() {
        movieDetailViewModel = MovieDetailViewModel(delegate: self)
    }

    override func tearDown() {
        movieDetailViewModel = nil
    }
    
    func testStrings() {
        XCTAssertTrue("ATTENTION" == MovieDetailViewModel.Localizable.attention)
        XCTAssertTrue("WITHOUT_DURATION" == MovieDetailViewModel.Localizable.withoutDuration)
    }
    
    func testPresentableDuration() {
        movieDetailViewModel.movieDetailed = mockMovie()
        
        /// Take care with Language of the phone
        XCTAssertEqual(movieDetailViewModel.getPresentableDuration(), "2 h e 5 min")
    }
    
    func testPresentableGenres() {
        movieDetailViewModel.movieDetailed = mockMovie()
        
        XCTAssertEqual(movieDetailViewModel.getPresentableGenres(), "Comédia, Drama.")
    }
    
    func mockMovie(id: Int32 = 1) -> Movie {
        return Movie(popularity: nil,
        voteCount: nil,
        video: nil,
        posterPath: nil,
        id: id,
        adult: nil,
        backdropPath: nil,
        originalLanguage: nil,
        originalTitle: nil,
        genres: [Genre(id: 1, name: "Comédia"), Genre(id: 2, name: "Drama")],
        title: UUID().uuidString + " Title",
        voteAverage: nil,
        overview: nil,
        releaseDate: nil,
        budget: nil,
        homepage: nil,
        imdbId: nil,
        revenue: nil,
        runtime: 125,
        status: nil,
        tagline: nil)
    }
}

extension MovieDetailViewModelTests: PatternViewModelDelegate {
    func loaded(state: State) {}
}
