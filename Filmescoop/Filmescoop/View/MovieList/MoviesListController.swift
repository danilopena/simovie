//
//  ViewController.swift
//  Filmescoop
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

final class MoviesListController: UIViewController {

    // MARK: - Outlets and variables
    @IBOutlet private weak var tableViewMovies: UITableView?
    @IBOutlet private weak var orientationTopRated: UILabel!
    @IBOutlet private weak var collectionViewMostPopular: UICollectionView?

    private var isLoadingMoreMovies = false
    private var hasLoadedOneTime = false
    private var numberPage = 1
    private var idMovieToDetail: Int32?
    var movieViewModel: MovieViewModel!

    // MARK: - Native class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        movieViewModel = MovieViewModel(delegate: self)
        navigationItem.title = movieViewModel?.titleMovieControllerStr
        orientationTopRated.text = movieViewModel.topRatedOrientationStr
        
        #if !targetEnvironment(simulator)
        tryReachability()
        NotificationCenter.default.addObserver(self,
                     selector: #selector(statusManager),
                     name: .flagsChanged,
                     object: nil)
        #else
        callApis()
        #endif
    }
    
    // MARK: - Support methods
    
    /// This method will be responsible to verify if tableView reached the end to be paginated.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = movieViewModel else { return }
        
        if movieViewModel?.movies != nil && Network.reachability.status != .unreachable {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height {
                if !isLoadingMoreMovies {
                    if viewModel.verifyIfHasAnotherPage() {
                        addFooterView()
                    }
                }
            }
        }
    }
    
    /// This method make the tableFooterView with ActivityIndicator during the webservice call.
    func addFooterView() {
        isLoadingMoreMovies = true
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80.0))
        view.backgroundColor = UIColor.black
        
        let pagingSpinner = UIActivityIndicatorView(style: .whiteLarge)
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor.white
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.frame = CGRect(x: view.frame.width/2, y: 20, width: 0, height: 30)
        view.addSubview(pagingSpinner)
        tableViewMovies?.tableFooterView = view
        numberPage += 1
        movieViewModel?.getMovies(page: "\(numberPage)")
    }
    
    func tryReachability() {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            callApis()
        }
        catch {
            print("Unable to verify reachability ")
        }
    }
    
    func callApis() {
        movieViewModel?.getMovies()
        movieViewModel?.getTopRatedMovies()
    }
    
    @objc func statusManager(_ notification: Notification) {
        switch Network.reachability.status {
            case .unreachable:
                movieViewModel.movies = MovieRealm.getMoviesFromRealm()
                DispatchQueue.main.async {
                    self.tableViewMovies?.reloadData()
                }
            case .wwan:
                DispatchQueue.main.async {
                    self.tableViewMovies?.reloadData()
                }
            case .wifi:
                DispatchQueue.main.async {
                    self.tableViewMovies?.reloadData()
                }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.sendToMovieDetail {
            let controller = segue.destination as? MovieDetailController
            controller?.idMovie = idMovieToDetail
        }
    }
}

extension MoviesListController {
    enum Constants {
      static let collectionCellIdentifier = "topMovieCell"
      static let tableCellIdentifier = "movieCell"
    }
}

extension MoviesListController: MovieViewModelDelegate {
    func loaded(state: State) {
        switch state {
        case .success:
            DispatchQueue.main.async {
                if self.isLoadingMoreMovies {
                    self.isLoadingMoreMovies = false
                    self.tableViewMovies?.tableFooterView = nil
                }
                self.tableViewMovies?.reloadData()
            }
        case .failed(let error):
            self.showAlert(with: movieViewModel.attentionString, message: error)
        }
    }
    
    func loadedTopRated(state: State) {
        switch state {
        case .success:
            DispatchQueue.main.async {
                self.collectionViewMostPopular?.reloadData()
            }
        case .failed(let error):
            self.showAlert(with: movieViewModel.attentionString, message: error)
        }
    }
}

extension MoviesListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModel?.topRatedMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellIdentifier, for: indexPath) as? MovieCollectionCell {
            
            cell.movieViewModel = movieViewModel
            cell.applyStyle(row: indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieToCell = movieViewModel?.topRatedMovies?[indexPath.row] {
            idMovieToDetail = movieToCell.id
            performSegue(withIdentifier: SegueIdentifier.sendToMovieDetail, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 100)
    }
}

extension MoviesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel?.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellIdentifier) as? MovieTableCell,
              let movieToCell = movieViewModel?.movies?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.movieViewModel = movieViewModel
        cell.setupData(with: movieToCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieToCell = movieViewModel?.movies?[indexPath.row] {
            idMovieToDetail = movieToCell.id
            performSegue(withIdentifier: SegueIdentifier.sendToMovieDetail, sender: self)
        }
    }
}

