//
//  FeaturedSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by Adrian Dominguez on 12/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class FeaturedSectionLandingTableViewCell: UITableViewCell {
    var delegate:didSelectMoviesProtocol?
    // UI
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblCategory: UILabel!
    // Logic
    var insetCollection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 10.0, right: 32.0)
    lazy var sizeItem: CGSize = { [unowned self] in
        return CGSize(width: 90.0, height: self.collectionView.frame.height - self.insetCollection.bottom)
    }()
    
    
    var featureds: [MovieItem] = [] {
        didSet {
            self.collectionView.reloadData()
         
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: String(describing: FeaturedLandingCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(FeaturedLandingCollectionViewCell.self))
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //self.dataSection?.contentOfset = self.collectionView.contentOffset
    }
    
}


// MARK: UIcollectionViewDelegate

extension FeaturedSectionLandingTableViewCell: UICollectionViewDelegate {
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.didSelectMovies(item: self.featureds[indexPath.item] )
        
    }
}


// MARK: UICollectionViewDataSource

extension FeaturedSectionLandingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featureds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FeaturedLandingCollectionViewCell.self), for: indexPath) as? FeaturedLandingCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.featuredData = self.featureds[indexPath.item]
        return cell
    }
    
}


// MARK: - FlowLayout CollectionView Delegate

extension FeaturedSectionLandingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.sizeItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return self.insetCollection
    }
}

