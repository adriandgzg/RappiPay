//
//  CardLandingCollectionViewCell.swift
//  cencosud.supermercados
//
//  Created by Pilar Prospero on 19/10/21.
//

import UIKit

class CardLandingCollectionViewCell: UICollectionViewCell {

    // UI
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with title: String, pathImage: String) {
        self.imageView.loadFromWebImage(path: pathImage, completion: nil)
        self.descriptionLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
