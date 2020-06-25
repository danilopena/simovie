//
//  MovieCollectionCell.swift
//  Filmescoop
//
//  Created by Danilo Pena on 22/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

final class MovieCollectionCell: UICollectionViewCell {
    
    // MARK: - Outlets and variables
    @IBOutlet private weak var imagePoster: UIImageView! {
        didSet {
            imagePoster.layer.cornerRadius = imagePoster.frame.width/2
        }
    }
    @IBOutlet private weak var number: UILabel! {
        didSet {
            number.layer.shadowColor = UIColor.darkGray.cgColor
            number.layer.shadowRadius = 5.0
            number.layer.shadowOpacity = 1.0
            number.layer.shadowOffset = CGSize(width: 4, height: 4)
        }
    }
    var movieViewModel: MovieViewModel!
    
    // MARK: - Support methods

    func applyStyle(row: Int) {
        if let posterPath = movieViewModel.topRatedMovies?[row].posterPath {
            movieViewModel?.getImageMovie(path: posterPath, completion: { (img, error) in
                DispatchQueue.main.async {
                    if let image = img {
                        self.imagePoster.image = image
                    } else {
                        self.imagePoster.image = #imageLiteral(resourceName: "ic-no-photo")
                    }
                }
            })
        }
        number.text = "\(row + 1) ?? 0"

        switch row {
        case 0:
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.number.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                UIView.animate(withDuration: 1.0) {
                    self.number.transform = CGAffineTransform.identity
                }
            })
            number.textColor = Colors.gold
        case 1:
            number.textColor = Colors.silver
        case 2:
            number.textColor = Colors.bronze
        default:
            number.textColor = Colors.graybase_Gray1
        }
    }
}
