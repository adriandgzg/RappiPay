//
//  WorldsSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/13/21.
//

import UIKit
import RxSwift
import RxCocoa
import CencosudMobileCore
import CencosudNetworking

class WorldsSectionLandingTableViewCell: SectionLandingTableViewCell {
    
    // UI
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    // Logic
    lazy var sizeItem: CGSize = { [unowned self] in
        return CGSize(width: self.bounds.width, height: self.collectionView.frame.height)
    }()
    
    var worlds: [BannerSection] = [] {
        didSet {
            self.collectionView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: String(describing: WorldLandingCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(WorldLandingCollectionViewCell.self))
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dataSection?.contentOfset = self.collectionView.contentOffset
    }
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        
        if let worlds = dataSection.data as? [BannerSection] {
            self.worlds = worlds
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
                            self.worlds = data
                        }
                        dataSection.data = self.worlds
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

extension WorldsSectionLandingTableViewCell: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDataSource

extension WorldsSectionLandingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells = Int((CGFloat(self.worlds.count)/4.0).rounded(.up))
        self.pageView.numberOfPages = numCells
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(WorldLandingCollectionViewCell.self), for: indexPath) as? WorldLandingCollectionViewCell
        else { return UICollectionViewCell() }
        
        let finalPosition: Int = (indexPath.item * 4) + 4 < self.worlds.count ? (indexPath.item * 4) + 4 : self.worlds.count
        let worlds = Array(self.worlds[(indexPath.item * 4)..<finalPosition])
        cell.worldsData = worlds as [BannerSection]
        cell.delegate = self
        return cell
    }
    
}


// MARK: - FlowLayout CollectionView Delegate

extension WorldsSectionLandingTableViewCell: UICollectionViewDelegateFlowLayout {
    
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


// MARK: - FlowLayout CollectionView Delegate

extension WorldsSectionLandingTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collection = scrollView as? UICollectionView else { return }
        
        let width = collection.bounds.width
        
        let offsetX = collection.contentOffset.x
        self.pageView.currentPage = Int(offsetX/width)
    }
}


// MARK: - WorldLandingCollectionViewCellDelegate

extension WorldsSectionLandingTableViewCell: WorldLandingCollectionViewCellDelegate {
    func didTapWorld(cell: WorldLandingCollectionViewCell, index: Int) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            let initialPosition = indexPath.item * 4
            let position = index + initialPosition
            print(position)
            if position < self.worlds.count {
                self.handleTapBanner(banner: self.worlds[position])
            }
        }
    }
}
