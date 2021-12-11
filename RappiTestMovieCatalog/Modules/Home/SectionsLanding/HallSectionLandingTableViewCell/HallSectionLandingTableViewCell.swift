//
//  HallSectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/13/21.
//

import UIKit
import RxSwift
import CencosudNetworking
import CencosudMobileCore


class HallSectionLandingTableViewCell: SectionLandingTableViewCell {
    
    // UI
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hallView: UIView!
    @IBOutlet weak var hallImageView: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundNameView: UIView!
    
    //Logic
    let insetColletion: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    let aspectRatio: CGFloat = 145.0/170.0
    let itemSpacing: CGFloat = 16.0
    lazy var sizeCell: CGSize = { [unowned self] in
        let collectionHeight = self.collectionView.frame.height
        
        return CGSize(width: collectionHeight * aspectRatio, height: collectionHeight)
    }()
    var products: [Product] = [] {
        didSet {
            self.collectionView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.arrowImage.image = self.arrowImage.image?.withRenderingMode(.alwaysTemplate)
        self.arrowImage.tintColor = .white
        
        
        self.collectionView.register(UINib(nibName: String(describing: ProductCollectionViewCell.self), bundle: nil) , forCellWithReuseIdentifier: NSStringFromClass(ProductCollectionViewCell.self))
        self.collectionView.register(SeeMoreProductsFooterCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(SeeMoreProductsFooterCollectionView.self))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset = self.insetColletion
        
        
        self.backgroundNameView.addCornerRadius()
        
        
        let tapGesture = UITapGestureRecognizer()
        self.hallView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self]recognizer in
            guard let `self` = self else { return }
            
            if let object = self.dataSection?.parameter as? HallLanding,
               let catalog = self.viewModel?.catalog,
               let categories = catalog.categories,
               let filter = object.filter {
                
                if let productCategory = self.viewModel?.searchProductCategoryByFilterParameter(parameter: filter, productsCategory: categories) {
                    
                    self.coordinator?.startHall(with: productCategory, catalog: catalog)
                }
            }
            
        }).disposed(by: self.disposeBag)
        self.hallImageView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dataSection?.contentOfset = self.collectionView.contentOffset
        self.products.removeAll()
    }
    
    override func fillUI(dataSection: SectionLanding) {
        super.fillUI(dataSection: dataSection)
        
        self.topFailedServiceViewConstraint?.constant = self.collectionView.frame.minY +
        10.0
        
        guard let data = dataSection.parameter as? HallLanding else {
            return
        }
        self.hallImageView.loadFromWebImage(path: data.image, completion: nil)
        self.nameLabel.text = data.name
        
        
        if let products = dataSection.data as? [Product] {
            self.products = products
        }
        self.collectionView.contentOffset = self.dataSection?.contentOfset ?? .zero
    }
    
    override func getData(dataSection: SectionLanding) {
        super.getData(dataSection: dataSection)
        
        if let viewModel = viewModel {
            if let object = dataSection.parameter as? HallLanding {
                return viewModel.getLocalProducts(filter: object.filter)
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
    
    func openCollection() {
        if let object = self.dataSection?.parameter as? HallLanding,
           let catalog = self.viewModel?.catalog,
           let categories = catalog.categories,
           let filter = object.filter {
            
            if let productCategory = self.viewModel?.searchProductCategoryByFilterParameter(parameter: filter, productsCategory: categories) {
                
                self.coordinator?.startHall(with: productCategory, catalog: catalog)
            }
        }
    }

}


extension HallSectionLandingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells = self.products.count
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProductCollectionViewCell.self), for: indexPath) as? ProductCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.product = self.products[indexPath.row]
        cell.parentCoordinator = self.coordinator
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(SeeMoreProductsFooterCollectionView.self), for: indexPath) as! SeeMoreProductsFooterCollectionView
        
        view.delegate = self
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return self.products.count == 0 ? .zero : self.sizeCell
    }
}


extension HallSectionLandingTableViewCell: SeeMoreProductsFooterCollectionViewDelegate {
    
    func didTapSeeMore() {
        if let object = self.dataSection?.parameter as? HallLanding,
           let catalog = self.viewModel?.catalog,
           let categories = catalog.categories,
           let filter = object.filter {
            
            if let productCategory = self.viewModel?.searchProductCategoryByFilterParameter(parameter: filter, productsCategory: categories) {
                
                self.coordinator?.startHall(with: productCategory, catalog: catalog)
            }
        }
    }
}
