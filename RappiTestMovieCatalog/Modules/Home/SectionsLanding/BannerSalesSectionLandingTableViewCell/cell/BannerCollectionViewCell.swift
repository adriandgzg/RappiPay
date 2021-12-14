//
//  Abstracts.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import UIKit
import AlamofireImage
class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    var banner: MovieItem? {
        didSet {
            guard let pathImage = banner?.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500" + pathImage) else { return }
            self.imgBanner.af_setImage(withURL:url)
            self.lblTitle.text = banner?.title ?? ""
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgBanner.addCornerRadius(Radius: 10)
    }

}
