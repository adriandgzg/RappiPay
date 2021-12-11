//
//  HomeView.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import UIKit

class HomeView: UIViewController{
    var presenter:HomeMoviesModuleInterface?
    var dataSource:HomeModel?
    @IBOutlet weak var tableViewHome: UITableView!
    
    
    
    func setPresenter(presenter:HomeMoviesModuleInterface){
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateView()
        // Do any additional setup after loading the view.
    }


}



extension HomeView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let isFromSearch = self.dataSource?.isFromSearch {
            return isFromSearch ? 1:3
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}


extension HomeView: HomeViewInterface {
   
    
    func showMoviesData(moviesData: HomeModel) {
        self.dataSource = moviesData
        dump(self.dataSource)
        self.tableViewHome.reloadData()
    }
    
    
    func showNoContentScreen() {
        
    }
    
}


