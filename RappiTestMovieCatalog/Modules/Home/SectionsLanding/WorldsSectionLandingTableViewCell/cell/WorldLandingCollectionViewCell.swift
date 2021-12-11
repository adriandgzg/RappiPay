//
//  WorldLandingCollectionViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/17/21.
//

import UIKit
import RxSwift
import RxCocoa
import CencosudMobileCore
import CencosudNetworking

protocol WorldLandingCollectionViewCellDelegate: AnyObject {
    func didTapWorld(cell: WorldLandingCollectionViewCell, index: Int)
}

class WorldLandingCollectionViewCell: UICollectionViewCell {

    // UI
    @IBOutlet var worldsImages: [UIImageView]!
    @IBOutlet var worldsNameLabels: [UILabel]!
    
    
    private let disposeBag: DisposeBag = DisposeBag()
    weak var delegate: WorldLandingCollectionViewCellDelegate?
    
    // Logic
    var worldsData: [BannerSection]? {
        willSet {
            guard let value = newValue else {
                return
            }
            
            for i in 0 ..< value.count {
                self.worldsImages[i].loadFromWebImage(path: value[i].image, completion: nil)
                self.worldsImages[i].alpha = 1.0
                self.worldsImages[i].isUserInteractionEnabled = true
                self.worldsNameLabels[i].text = value[i].name
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for i in 0 ..< self.worldsImages.count {
            self.worldsImages[i].alpha = 0.0
            self.worldsImages[i].isUserInteractionEnabled = false
            self.worldsNameLabels[i].text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0 ..< self.worldsImages.count {
            let tapGesture = UITapGestureRecognizer()
            self.worldsImages[i].addGestureRecognizer(tapGesture)
            tapGesture.rx.event.bind(onNext: { [weak self]recognizer in
                guard let `self` = self else { return }
                self.delegate?.didTapWorld(cell: self, index: i)
            }).disposed(by: self.disposeBag)
            self.worldsImages[i].isUserInteractionEnabled = true
        }
    }
}
