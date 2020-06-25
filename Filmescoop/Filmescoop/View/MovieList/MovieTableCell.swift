//
//  MovieTableCell.swift
//  Filmescoop
//
//  Created by Danilo Pena on 20/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import SkeletonView
import UIKit

final class MovieTableCell: UITableViewCell {

    // Mark: - Outlets and variables
    @IBOutlet private weak var imageMovie: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var voteAverage: UILabel!
    @IBOutlet private weak var voteAverageOrientation: UILabel!

    var movieViewModel: MovieViewModel?

    // MARK: - Native class methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageMovie.image = UIImage()
    }
    
    // MARK: - Support methods

    func setupData(with movie: Movie) {
        voteAverageOrientation.text = movieViewModel?.voteAverageOrientaitonStr
        if let vote = movie.voteAverage {
            voteAverage.text = "\(vote)"
            switch vote {
            case 0..<5:
                voteAverage.textColor = Colors.greenBase_Green3
            case 5..<8:
                voteAverage.textColor = Colors.greenBase_Green2
            default:
                voteAverage.textColor = Colors.greenBase_Green1
            }
        }

        titleMovie.text = movie.title
        
        if let posterPath = movie.backdropPath {
            movieViewModel?.getImageMovie(path: posterPath, completion: { (img, error) in
                DispatchQueue.main.async {
                    if let image = img {
                        self.imageMovie.image = image
                    } else {
                        self.imageMovie.image = #imageLiteral(resourceName: "ic-no-photo")
                    }
                }
            })
        }
    }
}
