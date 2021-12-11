//
//  BannerHeaderTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/26/21.
//

import UIKit
import RxSwift
import RxCocoa
import CencosudNetworking
import CencosudMobileCore

class BannerHeaderTableViewCell: SectionLandingTableViewCell {
    
    // UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Logic
    lazy var sizeItem: CGSize = { [unowned self] in
        return self.collectionView.frame.size
    }()
    
    
    var banners: [BannerSection] = [] {
        didSet {
            self.collectionView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: String(describing: BannerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(BannerCollectionViewCell.self))
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dataSection?.contentOfset = self.collectionView.contentOffset
    }
    
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        
        if let banners = dataSection.data as? [BannerSection] {
            self.banners = banners
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
                            self.banners = data
                        }
                        dataSection.data = self.banners
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


// MARK: UICollectionViewDataSource

extension BannerHeaderTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells = self.banners.count
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BannerCollectionViewCell.self), for: indexPath) as? BannerCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.banner2 = self.banners[indexPath.item]
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension BannerHeaderTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handleTapBanner(banner: self.banners[indexPath.item])
    }
}


// MARK: - FlowLayout CollectionView Delegate

extension BannerHeaderTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.sizeItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .zero
    }
}
