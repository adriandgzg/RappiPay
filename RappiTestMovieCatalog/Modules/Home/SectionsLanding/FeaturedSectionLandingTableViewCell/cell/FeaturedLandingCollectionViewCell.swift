//
//  FeaturedLandingCollectionViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/20/21.
//

import UIKit
import CencosudNetworking
import CencosudMobileCore

class FeaturedLandingCollectionViewCell: UICollectionViewCell {
    
    // UI
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var featuredNameLabel: UILabel!
    
    // Logic
    var featuredData: BannerSection? {
        willSet {
            guard let value = newValue else {
                return
            }
            
            self.featuredImage.loadFromWebImage(path: value.image, completion: nil)
            self.featuredImage.addCornerRadius()
            
            
            self.featuredNameLabel.text = value.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
