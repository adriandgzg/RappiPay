//
//  CardsSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/13/21.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import CencosudNetworking
import CencosudMobileCore


class CardsSectionLandingTableViewCell: SectionLandingTableViewCell {
    
    // UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Logic
    lazy var itemSize: CGSize = { [unowned self] in
        return CGSize(width: 152.0, height: self.collectionView.frame.height)
    }()
    
    // Data
    var carouselData: [BannerSection] = [] {
        didSet {
            self.collectionView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: String(describing: CardLandingCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(CardLandingCollectionViewCell.self))
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dataSection?.contentOfset = self.collectionView.contentOffset
    }
    
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        
        if let carouselData = dataSection.data as? [BannerSection] {
            self.carouselData = carouselData
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
                            self.carouselData = data
                        }
                        dataSection.data = self.carouselData
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

extension CardsSectionLandingTableViewCell: UICollectionViewDelegate {
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handleTapBanner(banner: self.carouselData[indexPath.item])
    }
}


// MARK: UICollectionViewDataSource

extension CardsSectionLandingTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CardLandingCollectionViewCell.self), for: indexPath) as? CardLandingCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: carouselData[indexPath.row].name, pathImage: carouselData[indexPath.row].image)

        return cell
    }
    
}


// MARK: - FlowLayout CollectionView Delegate

extension CardsSectionLandingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .zero
    }
}
