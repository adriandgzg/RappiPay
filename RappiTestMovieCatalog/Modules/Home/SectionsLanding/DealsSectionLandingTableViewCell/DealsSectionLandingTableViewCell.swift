//
//  RecentsSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/13/21.
//

import UIKit
import RxSwift
import CencosudMobileCore

class DealsSectionLandingTableViewCell: SectionLandingTableViewCell {
    
    @IBOutlet weak var recomendationViewCollection: UICollectionView!
    let insetColletion: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    let aspectRatio: CGFloat = 145.0/170.0
    let itemSpacing: CGFloat = 16.0
    lazy var sizeCell: CGSize = { [unowned self] in
        let collectionHeight = self.recomendationViewCollection.frame.height
        
        return CGSize(width: collectionHeight * aspectRatio, height: collectionHeight)
    }()
    var products: [Product] = [] {
        didSet {
            self.recomendationViewCollection.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.recomendationViewCollection.register(UINib(nibName: String(describing: ProductCollectionViewCell.self), bundle: nil) , forCellWithReuseIdentifier: NSStringFromClass(ProductCollectionViewCell.self))
        self.recomendationViewCollection.register(FooterPaginationCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(FooterPaginationCollectionReusableView.self))
        self.recomendationViewCollection.register(UINib(nibName: String(describing: ErrorNetworkCollectionViewCell.self), bundle: nil) , forCellWithReuseIdentifier: NSStringFromClass(ErrorNetworkCollectionViewCell.self))
        self.recomendationViewCollection.dataSource = self
        self.recomendationViewCollection.delegate = self
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        if let products = dataSection.data as? [Product] {
            self.products = products
        }
        
        self.recomendationViewCollection.contentOffset = self.dataSection?.contentOfset ?? .zero
        
    }
    
    override func getData(dataSection: SectionLanding) {
        super.getData(dataSection: dataSection)
        if let viewModel = viewModel {
            return viewModel.getProducts(typeSearch: .deals)
                .subscribe(on: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] products  in
                    guard  let`self` = self else {return}
                    
                    DispatchQueue.main.async {
                        if self.dataSection?.idData == dataSection.idData {
                            self.products = products
                        }
                        dataSection.data = self.products
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


extension DealsSectionLandingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells = self.products.count
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProductCollectionViewCell.self), for: indexPath) as? ProductCollectionViewCell
        else { return UICollectionViewCell() }
        
        
        cell.product = self.products[indexPath.item]
        cell.parentCoordinator = self.coordinator
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetColletion
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.itemSpacing
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //            if viewModel?.products.count == nil || viewModel?.products.count == 0 {
    //                self.getProducts()
    //            }
    //
    //
    //
    //    }
    
}
