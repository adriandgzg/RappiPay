//
//  BannerCollectionViewCell.swift
//  WongCencosud
//
//  Created By Gabriel Castillo on 16/06/21.
//

import UIKit
import CencosudMobileCore

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgBanner: UIImageView!
    
    
    //FIXME: Keep a model
    var banner: Banner? {
        didSet {
            guard let pathImage = banner?.image else { return }
            self.imgBanner.loadFromWebImage(path: pathImage, completion: nil)
        }
    }
    
    var banner2: BannerSection? {
        didSet {
            guard let pathImage = banner2?.image else { return }
            self.imgBanner.loadFromWebImage(path: pathImage, completion: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgBanner.addCornerRadius(Radius: 10)
    }

}
