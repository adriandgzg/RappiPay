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
    let searchBar = UISearchBar()
    var isSearch = false {
        didSet{
            self.tableViewHome.reloadData()
        }
    }
    
    func setPresenter(presenter:HomeMoviesModuleInterface){
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.updateView()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupSearchBar()
    }
    func setupSearchBar(){
        
           searchBar.searchBarStyle = UISearchBar.Style.prominent
           searchBar.placeholder = " Buscar..."
           searchBar.sizeToFit()
           searchBar.isTranslucent = false
           searchBar.backgroundImage = UIImage()
           searchBar.delegate = self
           searchBar.showsCancelButton = true
           let view = searchBar
           view.alpha = 0
        
           view.frame = CGRect(x:10, y: 40, width: searchBar.frame.width - 12, height: 44)
           UIView.animate(withDuration: 0.3) {
               view.alpha = 1
           }
           self.navigationController?.view.addSubview(searchBar)
    }
    func setupUI() {
        
        // tableViewHome
        let headerView = UIView(frame: CGRect(x: 50, y: 50, width: self.tableViewHome.bounds.width - 50, height: 10))
        self.tableViewHome.tableHeaderView = headerView
        self.tableViewHome.register(UINib(nibName: String(describing: BannerHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(BannerHeaderTableViewCell.self))
        self.tableViewHome.register(UINib(nibName: String(describing: FeaturedSectionLandingTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(FeaturedSectionLandingTableViewCell.self))
        self.tableViewHome.register(UINib(nibName: String(describing: SearchResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(SearchResultTableViewCell.self))
        
        self.tableViewHome.dataSource = self
        self.tableViewHome.delegate = self
     
    }
    
}
extension HomeView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
               isSearch = true
        }
           
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
               searchBar.resignFirstResponder()
               isSearch = false
          
        }
           
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
               searchBar.resignFirstResponder()
               isSearch = false
        }
        

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.count == 0 {
                isSearch = false
               
            } else {
                if searchText.count == 3{
                    
                    isSearch = true
                    self.presenter?.searchMovies(query: searchText)
                }
            }
        }
    
}

extension HomeView:didSelectMoviesProtocol {
    func didSelectMovies(item: MovieItem) {
        self.presenter?.showDetailsForMovie(movieData: item)
        self.searchBar.removeFromSuperview()
    }
}


extension HomeView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        }
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return self.dataSections?.searchMovies.count ?? 1
        }
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

    func getSearchCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchResultTableViewCell.self)) as? SearchResultTableViewCell
        else {
            let cellNoResult = SearchResultTableViewCell()
            cellNoResult.lblREsultSearch.text = "Sin resultados"
            return cellNoResult
        }
        cell.lblREsultSearch.text = self.dataSections?.searchMovies[indexPath.row].title
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
            if isSearch {
                return getSearchCell(tableView, cellForRowAt: indexPath)
            }
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
extension HomeView:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch {
            if let item = self.dataSections?.searchMovies[indexPath.row]
            {
                
                self.presenter?.showDetailsForMovie(movieData: item)
                self.searchBar.removeFromSuperview()
            }
            
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


