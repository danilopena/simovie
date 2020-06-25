//
//  MovieViewModel.swift
//  Filmescoop
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit
import RealmSwift

protocol MovieViewModelDelegate: class {
    func loaded(state: State)
    func loadedTopRated(state: State)
}

final class MovieViewModel {
    private let networkLayer: NetworkLayer
    var movieWrapper: MovieWrapper?
    var movies: [Movie]?
    private(set) var topRatedMovies: [Movie]?
    private weak var delegate: MovieViewModelDelegate?

    init(delegate: MovieViewModelDelegate, networkLayer: NetworkLayer = NetworkLayer()) {
        self.delegate = delegate
        self.networkLayer = networkLayer
    }
    
    func verifyIfHasAnotherPage() -> Bool {
        guard let totalResults = movieWrapper?.totalResults,
              let moviesCount = movies?.count
        else { return false }
        if Int32(moviesCount) < totalResults {
            return true
        }
        return false
    }
    
    func getMovies(page: String = "1") {
        let successHandler: (MovieWrapper) -> Void = { [weak self] (wrapper) in
            if let movies = wrapper.results {
                if self?.movies == nil {
                    self?.movies = movies
                } else {
                    self?.movies?.append(contentsOf: movies)
                }
                _ = self?.addMoviesOnLocalStorage()
                                
                self?.movieWrapper = wrapper
                self?.delegate?.loaded(state: .success)
            }
        }
        let errorHandler: (String) -> Void = { [weak self] (error) in
            self?.delegate?.loaded(state: .failed(error: error))
        }

        networkLayer.get(urlString: NetworkLayer.Constants.baseUrl + Endpoint.moviePopular + "?api_key=\(NetworkLayer.Constants.apiKey)" + "&page=" + page + NetworkLayer.Constants.language,
                         successHandler: successHandler,
                         errorHandler: errorHandler)
    }
    
    func addMoviesOnLocalStorage() -> NSError? {
        var error: NSError?
        self.movies?.forEach({ (movie) in
            let movieRealm = movie.toMovieRealm()
            /// Avoiding distubing the user with erros
            let filter = MovieRealm.getMoviesFromRealm()?.filter({ $0.id == movie.id })
            if filter?.count == 0 || filter == nil {
                error = RealmManager.addObjectInRealm(object: movieRealm)
            }
        })
        return error
    }
    
    func getTopRatedMovies() {
        let successHandler: (MovieWrapper) -> Void = { [weak self] (wrapper) in
            if let topRated = wrapper.results {
                var top5: [Movie]? = []
                for (index, movie) in topRated.enumerated() {
                    if index >= 5 {
                        continue
                    }
                    top5?.append(movie)
                }
                
                self?.topRatedMovies = top5
                self?.delegate?.loadedTopRated(state: .success)
            }
        }
        let errorHandler: (String) -> Void = { [weak self] (error) in
            self?.delegate?.loadedTopRated(state: .failed(error: error))
        }

        networkLayer.get(urlString: NetworkLayer.Constants.baseUrl + Endpoint.moviesTopRated + "?api_key=\(NetworkLayer.Constants.apiKey)" + "&page=1" + NetworkLayer.Constants.language,
                         successHandler: successHandler,
                         errorHandler: errorHandler)
    }
    
    func getImageMovie(path: String, completion: @escaping (UIImage?, String?) -> Void) {
        let successHandler: (UIImage) -> Void = { (img) in
            completion(img, nil)
        }
        
        let errorHandler: (String) -> Void = { (error) in
            completion(nil, error)
        }
        
        networkLayer.getImage(urlString: NetworkLayer.Constants.baseUrlImage + "w185/" + path,
        successHandler: successHandler,
        errorHandler: errorHandler)
    }
}

extension MovieViewModel {
    enum Localizable {
        static let titleMovieController = "TITLE_MOVIE_CONTROLLER"
        static let attention = "ATTENTION"
        static let voteAverageOrientaiton = "VOTE_AVERAGE_ORIENTATION"
        static let topRatedOrientation = "TOP_RATED_ORIENTATION"
    }
    
    var titleMovieControllerStr: String {
        return Localizable.titleMovieController.localized
    }
    
    var attentionString: String {
        return Localizable.attention.localized
    }
    
    var voteAverageOrientaitonStr: String {
        return Localizable.voteAverageOrientaiton.localized
    }
    
    var topRatedOrientationStr: String {
        return Localizable.topRatedOrientation.localized
    }
}
