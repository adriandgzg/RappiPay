import UIKit
import RxSwift
import RxCocoa
class BannerHeaderTableViewCell: UITableViewCell {
    var delegate : didSelectMoviesProtocol?
    // UI
    @IBOutlet weak var contraintHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var mimiVersion = false
    // Logic
    lazy var sizeItem: CGSize = { [unowned self] in
        return  self.collectionView.frame.size
    }()
    
    
    var banners: [MovieItem] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        self.collectionView.register(UINib(nibName: String(describing: BannerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(BannerCollectionViewCell.self))
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        contentOfset = self.collectionView.contentOffset
    }
    
    }



// MARK: UICollectionViewDataSource

extension BannerHeaderTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells = self.banners.count
        return numCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell : BannerCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BannerCollectionViewCell.self), for: indexPath) as? BannerCollectionViewCell
        else { return UICollectionViewCell() }
     
        cell.banner = self.banners[indexPath.row]
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension BannerHeaderTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectMovies(item: self.banners[indexPath.item])
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
        if mimiVersion {
            return CGSize(width: self.sizeItem.width / 3, height: self.sizeItem.height)
                
        }
        return CGSize(width: self.sizeItem.width / 1.4, height: self.sizeItem.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .zero
    }
}
