//
//  MenuViewController.swift
//  cencosud.supermercados
//
//  Created by edwin sierra on 28/07/2021.
//

import UIKit
import CencosudMobileCore
import CencosudNetworking

protocol MenuViewControllerDelegate: AnyObject {
    func MenuViewControllerDidTapCloseMenu()
    func MenuViewControllerDidTapOption(option: MenuOption)
    func MenuViewControllerDidTapLogOff()
    func MenuViewControllerDidTapCallHelp()
}
enum MenuOption {
    case shoppingHistory, myData, stores, tc, pp, complaintBook
    
    var descriptionTitle: String {
        get {
            switch self {
            case .shoppingHistory:
                return "Historial de compras"
            case .myData:
                return "Mis datos"
            case .stores:
                return "Locales \(Constants.appName.capitalized)"
            case .tc:
                return "Términos y condiciones"
            case .pp:
                return "Políticas de privacidad"
            case .complaintBook:
                return "Libro de reclamaciones"
            }
        }
    }
    
    var iconName: String {
        get {
            switch self {
            case .shoppingHistory:
                return "historialCompras"
            case .myData:
                return "misDatos"
            case .stores:
                return "miDireccion"
            case .tc:
                return "terminos"
            case .pp:
                return "politicas"
            case .complaintBook:
                return "reclamos"
            }
        }
    }
}

enum MenuSection: CaseIterable {
    case acountInfo, generalInfo
    
    var descriptionTitle: String {
        get {
            switch self {
            case .acountInfo:
                return "Información de cuenta"
            case .generalInfo:
                return "Información"
            }
        }
    }
    
    var options: [MenuOption] {
        get {
            switch self {
            case .acountInfo:
                return [.shoppingHistory,.myData]
            case .generalInfo:
                return [.stores, .tc, .pp, .complaintBook]
            }
        }
    }
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let categoriaMenuId = "MenuCategoryTableViewCell"
 
    var sections: [MenuSection] = MenuSection.allCases
    weak var menuDelegate: MenuViewControllerDelegate?
    var menuProfileView:MenuProfileView!
    weak var coordinator: MoreCoordinator?

    
    
    // MARK: - inicialization
    
    static func initView() -> MenuViewController {
        let vc = MenuViewController.instantiate()
        vc.view.layoutIfNeeded()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view.maskedCornersView = [.layerMaxXMinYCorner]
        tableView.register(UINib(nibName: "MenuCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCategoryTableViewCell")
        loadProfileView()
        loadFooterView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RewardsManager.sharedInstance.updateRewards()
        self.fillProfileView()
        refreshFooterDelegate()
    }
    
    func refreshFooterDelegate(){
        if let footer =  self.tableView.tableFooterView  as? MenuFooterView{
            footer.delegate = self.menuDelegate
        }
    }
    
    @IBAction func onTapCloseMenu(_ sender: Any) {
        self.menuDelegate?.MenuViewControllerDidTapCloseMenu()
    }
    
    func fillProfileView(){
//        menuProfileView.distanceLabel.text = viewModel?.distanceToClosest
//        menuProfileView.cuponsLabel.text = "\(viewModel?.couponTotal ?? 0)"
        menuProfileView.distanceLabel.text = AuthManager.sharedInstance.distanceToClosest
        menuProfileView.cuponsLabel.text = "\(AuthManager.sharedInstance.couponTotal)"
        menuProfileView.bonusPointsLabel.text = "\(RewardsManager.sharedInstance.rewards?.rewards ?? 0)"
        menuProfileView.nameLabel.text = AuthManager.sharedInstance.userProfile?.fullName
        menuProfileView.mailLabel.text = AuthManager.sharedInstance.userProfile?.email
        self.tableView.setContentOffset(.zero, animated: false)
    }
    
    func loadProfileView() {
        menuProfileView = MenuProfileView()
        self.tableView.tableHeaderView = menuProfileView
        menuProfileView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        menuProfileView.setNeedsLayout()
        menuProfileView.layoutIfNeeded()
        menuProfileView.frame.size =
            menuProfileView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableView.tableHeaderView = menuProfileView
    }
    
    func loadFooterView() {
        let footerView = MenuFooterView()
        self.tableView.tableFooterView = footerView
        footerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
       // footerView.delegate = self
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        footerView.frame.size =
            footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
       
        self.tableView.tableFooterView = footerView
        if let footer =  self.tableView.tableFooterView  as? MenuFooterView{
            footer.delegate = self.menuDelegate
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}

extension MenuViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCategoryTableViewCell") as! MenuCategoryTableViewCell
        let items = self.sections[indexPath.section].options
        let item = items[indexPath.row]
            
        cell.lbName.text = item.descriptionTitle
        let imageView = UIImage(named:item.iconName)
        cell.img.image = imageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0))
        let titleLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: view.frame.size.width - 30.0, height: 50.0))
        titleLabel.font = UIFont.robotoBlack(size: 16.0)
        let title = sections[section].descriptionTitle
        titleLabel.text = title
        
        view.addSubview(titleLabel)
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let items = self.sections[indexPath.section].options
        let item = items[indexPath.row]
        print("You selected cell #\(item.descriptionTitle)!")
        self.coordinator?.handleMenuOptions(option: item)
        //menuDelegate?.MenuViewControllerDidTapOption(option: item)
    }
    
}

extension MenuViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

