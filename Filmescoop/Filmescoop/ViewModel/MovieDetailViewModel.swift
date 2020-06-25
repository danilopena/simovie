//
//  MovieDetailViewModel.swift
//  Filmescoop
//
//  Created by Danilo Pena on 21/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit


protocol PatternViewModelDelegate: class {
    func loaded(state: State)
}

final class MovieDetailViewModel {
    private let networkLayer: NetworkLayer
    var movieDetailed: Movie?
    private weak var delegate: PatternViewModelDelegate?

    init(delegate: PatternViewModelDelegate, networkLayer: NetworkLayer = NetworkLayer()) {
        self.delegate = delegate
        self.networkLayer = networkLayer
    }
    
    func getMovieDetails(id: Int32) {
        let successHandler: (Movie) -> Void = { [weak self] (movie) in
            self?.movieDetailed = movie
            self?.delegate?.loaded(state: .success)
        }
        let errorHandler: (String) -> Void = { (error) in
            self.delegate?.loaded(state: .failed(error: error))
        }

        networkLayer.get(urlString: NetworkLayer.Constants.baseUrl + Endpoint.movieDetails + "\(id)" + "?api_key=\(NetworkLayer.Constants.apiKey)" + NetworkLayer.Constants.language,
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
                              errorHandler: errorHandler
        )
    }
    
    func getPresentableDuration() -> String? {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: NSLocale.preferredLanguages.first ?? "pt-BR")
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.calendar = calendar

        if let time = movieDetailed?.runtime, let formattedString = formatter.string(from: TimeInterval(time * 60)) {
            return time == 0 ? withoutDuration : formattedString
        }
        return nil
    }
    
    func getPresentableGenres() -> String {
        var genreStr = ""
        movieDetailed?.genres?.forEach({ (genre) in
            if (genre.id == movieDetailed?.genres?.last?.id) || (movieDetailed?.genres?.count == 1) {
                genreStr.append("\(genre.name ?? "").")
            } else {
                genreStr.append("\(genre.name ?? ""), ")
            }
        })
        return genreStr
    }
}

extension MovieDetailViewModel {
    enum Localizable {
        static let attention = "ATTENTION"
        static let withoutDuration = "WITHOUT_DURATION"
    }
    
    var attentionString: String {
        return Localizable.attention.localized
    }
    
    var withoutDuration: String {
        return Localizable.withoutDuration.localized
    }
}
