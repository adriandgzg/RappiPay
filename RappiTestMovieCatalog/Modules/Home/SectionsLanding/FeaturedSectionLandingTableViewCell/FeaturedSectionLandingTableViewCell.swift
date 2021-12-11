//
//  FeaturedSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/13/21.
//

import UIKit
import RxSwift
import RxCocoa
import CencosudNetworking
import CencosudMobileCore

class FeaturedSectionLandingTableViewCell: SectionLandingTableViewCell {
    
    // UI
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Logic
    var insetCollection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 10.0, right: 32.0)
    lazy var sizeItem: CGSize = { [unowned self] in
        return CGSize(width: 57.0, height: self.collectionView.frame.height - self.insetCollection.bottom)
    }()
    
    
    var featureds: [BannerSection] = [] {
        didSet {
            self.collectionView.reloadData()
            self.activityIndicator?.stopAnimating()
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
        
        self.dataSection?.contentOfset = self.collectionView.contentOffset
    }
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        
        if let featureds = dataSection.data as? [BannerSection] {
            self.featureds = featureds
        }
        
        self.collectionView.contentOffset = self.dataSection?.contentOfset ?? .zero
    }
    
    override func getData(dataSection: SectionLanding) {
        super.getData(dataSection: dataSection)
        
        if let viewModel = viewModel {
            return viewModel.getLandingSection(id: dataSection.id)
                .subscribe(on: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] data  in
                    guard  let`self` = self else {return}
                    
                    DispatchQueue.main.async {
                        if self.dataSection?.idData == dataSection.idData {
                            self.featureds = data
                        }
                        dataSection.data = self.featureds
                    }
                } onError: { [weak self] (error) in
                    guard  let`self` = self else {return}
                    DispatchQueue.main.async {
                        dataSection.status = .failedService
                        if self.dataSection?.idData == dataSection.idData {
                            self.fillUI(dataSection: dataSection)
                        }
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}


// MARK: UIcollectionViewDelegate

extension FeaturedSectionLandingTableViewCell: UICollectionViewDelegate {
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handleTapBanner(banner: self.featureds[indexPath.item])
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

