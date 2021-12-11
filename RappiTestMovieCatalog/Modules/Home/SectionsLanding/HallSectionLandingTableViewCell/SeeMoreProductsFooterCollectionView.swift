//
//  SeeMoreProductsFooterCollectionView.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 11/12/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SeeMoreProductsFooterCollectionViewDelegate: class {
    func didTapSeeMore()
}

class SeeMoreProductsFooterCollectionView: UICollectionReusableView {
    
    weak var delegate: SeeMoreProductsFooterCollectionViewDelegate?
    private let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        
        let plusImage: UIImageView = UIImageView()
        plusImage.image = UIImage(named: "plussIcon")
        self.addSubview(plusImage)
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        plusImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 45.0).isActive = true
        plusImage.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        plusImage.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        plusImage.clipsToBounds = true
        plusImage.contentMode = .scaleAspectFit
        
        
        let label: UILabel = UILabel()
        label.font = UIFont.robotoMedium(size: 14.0)
        self.addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Ver más\nproductos"
        label.textColor = Theme.primaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Theme.washedRed
        self.cornerRadiusView = 5
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: plusImage.bottomAnchor, constant: 10.0).isActive = true
        
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self]recognizer in
            guard let `self` = self else { return }
            
            self.delegate?.didTapSeeMore()
        }).disposed(by: self.disposeBag)
        label.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
