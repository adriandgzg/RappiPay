//
//  HomeView.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import UIKit

class HomeView: UIViewController{
    var presenter:HomeMoviesModuleInterface?
    var dataSections: HomeModel? {
        didSet {
            self.tableViewHome.reloadData()
        }
    }
    @IBOutlet weak var tableViewHome: UITableView!
    
    
    
    func setPresenter(presenter:HomeMoviesModuleInterface){
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.updateView()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        // tableViewHome
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewHome.bounds.width, height: 10))
        self.tableViewHome.tableHeaderView = headerView
        self.tableViewHome.register(UINib(nibName: String(describing: BannerHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(BannerHeaderTableViewCell.self))
        self.tableViewHome.register(UINib(nibName: String(describing: FeaturedSectionLandingTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(FeaturedSectionLandingTableViewCell.self))
        self.tableViewHome.dataSource = self
     
        
    }
    


}
extension HomeView:didSelectMoviesProtocol {
    func didSelectMovies(item: MovieItem) {
        self.presenter?.showDetailsForMovie(movieData: item)
    }
}


extension HomeView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func getBannerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BannerHeaderTableViewCell.self)) as? BannerHeaderTableViewCell
        else {
            return UITableViewCell()
        }
        cell.contraintHeight.constant = 270
        cell.mimiVersion = false
        if let movies = self.dataSections?.topRatedMovies {
            cell.banners = movies
        }
        cell.delegate = self
        return cell
     }

        
    
    func getMiniSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FeaturedSectionLandingTableViewCell.self)) as? FeaturedSectionLandingTableViewCell
        else {
            return UITableViewCell()
        }
        if let movies = self.dataSections?.upcomingMovies {
            cell.featureds = movies
        }
        cell.lblCategory.text = Section.Upcoming.rawValue
        cell.delegate = self
        return cell
    }
    
    func getMiniSectionForTopRated(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FeaturedSectionLandingTableViewCell.self)) as? FeaturedSectionLandingTableViewCell
        else {
            return UITableViewCell()
        }
        if let movies = self.dataSections?.topRatedMovies {
            cell.featureds = movies
        }
        cell.lblCategory.text = Section.TopRated.rawValue
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
           return getBannerCell(tableView, cellForRowAt: indexPath)
        case 1:
            return getMiniSectionForTopRated(tableView, cellForRowAt: indexPath)
        case 2:
            return getMiniSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
            
        }
    }
    
    
}

extension HomeView: HomeViewInterface {
    func showMoviesData(moviesData: HomeModel) {
        self.dataSections = moviesData
    }
    
    
    func showNoContentScreen() {
        
    }
    
}


