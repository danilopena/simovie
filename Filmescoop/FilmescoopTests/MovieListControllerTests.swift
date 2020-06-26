//
//  FilmescoopTests.swift
//  FilmescoopTests
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import XCTest
@testable import SiMovie

extension XCTestCase {
    func setupController<T: UIViewController>(storyboardName: String, identifier: String) -> T? {
        guard let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as? T else {
            XCTFail("Could not instantiate " + identifier + " from main storyboard")
            return nil
        }
        return vc
    }
}

final class MovieListControllerTests: XCTestCase {
    private var controller: MoviesListController!
    
    override func setUp() {
        super.setUp()
        
        controller = setupController(storyboardName: StoryboardIdentifier.main, identifier: "movieViewController")
        controller.movieViewModel = MovieViewModel(delegate: self)
        controller.movieViewModel.getMovies()
        controller.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        
        controller = nil
    }

}

extension MovieListControllerTests: MovieViewModelDelegate {
    func loaded(state: State) {
        switch state {
        case .success:
            XCTAssertNotNil(controller.movieViewModel.movies)
            XCTAssertTrue(controller.movieViewModel.movies?.count ?? 0 > 0)
        case .failed(let error):
            break
        }
    }
    
    func loadedTopRated(state: State) {}    
}
