//
//  MovieViewModelTests.swift
//  FilmescoopTests
//
//  Created by Danilo Pena on 23/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import XCTest
@testable import SiMovie

final class MovieViewModelTests: XCTestCase {

    private var movieViewModel: MovieViewModel!
        
    override func setUp() {
        movieViewModel = MovieViewModel(delegate: self)
    }

    override func tearDown() {
        movieViewModel = nil
    }
    
    func testStrings() {
        XCTAssertTrue("ATTENTION" == MovieViewModel.Localizable.attention)
        XCTAssertTrue("TITLE_MOVIE_CONTROLLER" == MovieViewModel.Localizable.titleMovieController)
        XCTAssertTrue("VOTE_AVERAGE_ORIENTATION" == MovieViewModel.Localizable.voteAverageOrientaiton)
    }
    
    func testVerifyHasAnotherPage() {
        movieViewModel.movieWrapper = MovieWrapper(page: 1, totalResults: 4, totalPages: 4, results: nil)
        movieViewModel.movies = [mockMovie(), mockMovie(), mockMovie()]
        
        /// If movieViewModel.movies < totalResults has another page.
        XCTAssertTrue(movieViewModel.verifyIfHasAnotherPage())
    }
    
    func testAddMoviesOnLocalStorage() {
        movieViewModel.movies = [mockMovie(), mockMovie(id: 2), mockMovie(id: 3)]
        
        XCTAssertNil(movieViewModel.addMoviesOnLocalStorage())
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
           genres: nil,
           title: UUID().uuidString + " Title",
           voteAverage: nil,
           overview: nil,
           releaseDate: nil,
           budget: nil,
           homepage: nil,
           imdbId: nil,
           revenue: nil,
           runtime: nil,
           status: nil,
           tagline: nil)
       }
}

extension MovieViewModelTests: MovieViewModelDelegate {
    func loaded(state: State) {}
    
    func loadedTopRated(state: State) {}
}
