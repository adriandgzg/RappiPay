//
//  FeaturedLandingCollectionViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/20/21.
//

import UIKit

class FeaturedLandingCollectionViewCell: UICollectionViewCell {
    
    // UI
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var featuredNameLabel: UILabel!
    
    // Logic
    var featuredData: MovieItem? {
        willSet {
            guard let value = newValue else {
                return
            }
            guard let pathImage = value.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500" + pathImage) else { return }
            self.featuredImage.af_setImage(withURL:url)
            
            self.featuredNameLabel.text = value.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
