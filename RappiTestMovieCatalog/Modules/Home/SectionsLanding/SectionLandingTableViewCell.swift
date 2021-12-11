//
//  SectionLandingTableViewCell.swift
//  cencosud.supermercados
//
//  Created by carlos jaramillo on 10/14/21.
//

import UIKit
import RxSwift
import RxCocoa
import CencosudNetworking
import CencosudMobileCore


@objcMembers
class SectionLandingTableViewCell: UITableViewCell {
    
    // UI
    var activityIndicator: UIActivityIndicatorView?
    lazy var failedServiceView: UIView = { [unowned self] in
        
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "E8E6E6")
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        
        self.topFailedServiceViewConstraint = view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0)
        self.topFailedServiceViewConstraint?.isActive = true
        
        self.bottomFailedServiceViewConstraint = view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0)
        self.bottomFailedServiceViewConstraint?.isActive = true
        
        self.leadingFailedServiceViewConstraint = view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0)
        self.leadingFailedServiceViewConstraint?.isActive = true
        
        self.trailingFailedServiceViewConstraint = view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0)
        self.trailingFailedServiceViewConstraint?.isActive = true
        view.alpha = 0.0
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.setTitle("RECARGAR", for: .normal)
        button.setTitleColor(Theme.buttonColor, for: .normal)
        button.backgroundColor = Theme.primaryColor
        button.titleLabel?.font = UIFont.robotoMedium(size: 17.0)
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(self.reload), for: .touchUpInside)
        button.addCornerRadius()
        
        return view
    }()
    
    var leadingFailedServiceViewConstraint: NSLayoutConstraint?
    var trailingFailedServiceViewConstraint: NSLayoutConstraint?
    var topFailedServiceViewConstraint: NSLayoutConstraint?
    var bottomFailedServiceViewConstraint: NSLayoutConstraint?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // Logic
    weak var coordinator: HomeCoordinator?
    weak var viewModel: HomeViewModel? {
        get {
            self.coordinator?.viewModel
        }
    }
    
    // Data
    weak var dataSection: SectionLanding? {
        didSet {
            guard let dataSection = self.dataSection else {
                return
            }
            self.fillUI(dataSection: dataSection)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.activityIndicator?.removeFromSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bind(coordinator: HomeCoordinator, dataSection: SectionLanding) {
        self.coordinator = coordinator
        self.dataSection = dataSection
    }
    
    func getData(dataSection: SectionLanding) {
        dataSection.status = .loadingData
    }
    
    func addActivity() {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .large
        } else {
            activity.style = .whiteLarge
        }
        activity.color = .gray
        activity.startAnimating()
        self.contentView.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.activityIndicator = activity
        activity.hidesWhenStopped = true
    }
    
    func fillUI(dataSection: SectionLanding) {
        switch dataSection.status {
        case .failedService:
            self.activityIndicator?.removeFromSuperview()
            AnimatorHelper.fadeIn(view: self.failedServiceView, speed: 0.3, completion: nil)
        case .firstLoad:
            self.addActivity()
            self.getData(dataSection: dataSection)
        case .loadedData:
            AnimatorHelper.fadeOut(view: self.failedServiceView, speed: 0.0, completion: nil)
            self.activityIndicator?.removeFromSuperview()
        case .loadingData:
            AnimatorHelper.fadeOut(view: self.failedServiceView, speed: 0.3, completion: nil)
            self.addActivity()
        }
    }
    
    func reload() {
        guard let dataSection = self.dataSection else {
            return
        }
        self.getData(dataSection: dataSection)
        self.fillUI(dataSection: dataSection)
    }
    
    func handleTapBanner(banner: BannerSection) {
        switch banner.type {
        case .collection:
            self.coordinator?.startBanner(with: banner)
        case .page:
            if let url = URL(string: banner.parameter) {
                self.coordinator?.startWebView(url: url)
            }
            self.coordinator?.startWebView(url: URL(string: "https://www.google.com/")!)
        case .image:
            self.coordinator?.startBannerImage(with: banner)
        default:
            print("mal")
        }
    }
}
