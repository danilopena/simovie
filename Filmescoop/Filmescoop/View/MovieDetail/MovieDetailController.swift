//
//  MovieDetailController.swift
//  Filmescoop
//
//  Created by Danilo Pena on 21/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import SkeletonView
import UIKit

final class MovieDetailController: UIViewController {

    // MARK: - Outlets and variables
    @IBOutlet private weak var imagePoster: UIImageView!
    @IBOutlet private weak var overView: UITextView!
    @IBOutlet private weak var genres: UILabel!
    @IBOutlet private weak var duration: UILabel!
    @IBOutlet private weak var clock: UIImageView!
    @IBOutlet private weak var separator: UIView! {
        didSet {
            separator.layer.cornerRadius = 2
        }
    }
    @IBOutlet private weak var blurredImage: UIImageView! {
        didSet {
            blurredImage.blurred()
        }
    }

    private var movieDetailViewModel: MovieDetailViewModel!
    /// Used to simplify logic to set the skeleton animation
    private var views: Array<UIView>?
    var idMovie: Int32?
    
    // MARK: - Native class methods
    override func viewDidLoad() {
        super.viewDidLoad()

        applySkeletonAnimation()
        movieDetailViewModel = MovieDetailViewModel(delegate: self)
        
        #if !targetEnvironment(simulator)
        tryReachability()
        NotificationCenter.default.addObserver(self,
                     selector: #selector(statusManager),
                     name: .flagsChanged,
                     object: nil)
        #else
        movieDetailViewModel.getMovieDetails(id: idMovie ?? 0)
        #endif

    }
    
    func tryReachability() {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            switch Network.reachability.status {
                case .unreachable:
                    movieDetailViewModel.movieDetailed = MovieRealm.getMovieFromRealm(with: idMovie ?? 0)
                    DispatchQueue.main.async {
                        self.removeSkeletonAfterLoaded()
                        self.applyData()
                    }
                case .wwan:
                    movieDetailViewModel.getMovieDetails(id: idMovie ?? 0)
                case .wifi:
                    movieDetailViewModel.getMovieDetails(id: idMovie ?? 0)
            }
        }
        catch {
            print("Unable to verify reachability ")
        }
    }
    
    // MARK: - Support methods

    private func applySkeletonAnimation() {
        views = [separator, blurredImage, imagePoster, overView, genres, duration, clock]
        
        views?.forEach({ (view) in
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .black, secondaryColor: .darkGray))
        })
    }
    
    private func removeSkeletonAfterLoaded() {
        views?.forEach({ (view) in
            view.hideSkeleton()
        })
    }
    
    @objc func statusManager(_ notification: Notification) {
        switch Network.reachability.status {
            case .unreachable:
                movieDetailViewModel.movieDetailed = MovieRealm.getMovieFromRealm(with: idMovie ?? 0)
                DispatchQueue.main.async {
                    self.removeSkeletonAfterLoaded()
                    self.applyData()
                }
            case .wwan:
                movieDetailViewModel.getMovieDetails(id: idMovie ?? 0)
            case .wifi:
                movieDetailViewModel.getMovieDetails(id: idMovie ?? 0)
        }
    }
    
    private func applyData() {
        guard let posterPath = movieDetailViewModel.movieDetailed?.posterPath,
            let backDropPath = movieDetailViewModel.movieDetailed?.backdropPath else {
                return
        }
        
        navigationItem.title = self.movieDetailViewModel.movieDetailed?.title
        overView.text = movieDetailViewModel.movieDetailed?.overview
        duration.text = movieDetailViewModel.getPresentableDuration() ?? movieDetailViewModel.withoutDuration
        genres.text = movieDetailViewModel.getPresentableGenres()

        /// Getting poster
        movieDetailViewModel.getImageMovie(path: posterPath) { (img, error) in
            DispatchQueue.main.async {
                if let image = img {
                    self.imagePoster.image = image
                } else {
                    self.imagePoster.image = #imageLiteral(resourceName: "ic-no-photo")
                }
            }
        }
        
        /// Getting backDrop to make blur on header.
        movieDetailViewModel.getImageMovie(path: backDropPath) { (img, error) in
            DispatchQueue.main.async {
                if let image = img {
                    self.blurredImage.image = image
                } else {
                    self.imagePoster.image = nil
                }
            }
        }
    }
}

extension MovieDetailController: PatternViewModelDelegate {
    func loaded(state: State) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.removeSkeletonAfterLoaded()
            switch state {
            case .success:
                DispatchQueue.main.async {
                    self.applyData()
                }
            case .failed(let error):
                self.showAlert(with: self.movieDetailViewModel.attentionString, message: error)
            }
        }
    }
}
