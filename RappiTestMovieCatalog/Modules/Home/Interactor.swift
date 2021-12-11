//
//  Interactor.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation


class HomeInteractor : HomeMoviesInteractorInput {
    
    
    var presenter: HomeMoviesInteractorOutput?
    var modules = HomeModel()
    func initVIPER(presenter:HomeMoviesInteractorOutput){
        self.presenter = presenter
    }
    
    func fetchMovies() {
        
        self.modules.isFromSearch = false
        //dependency injection
        let serviceManager = AsyncManager.shared
        let repository = MoviesRepository(serviceManagers: serviceManager)
        let dataSourcePopulatesMovies = PopuparMovies(repository: repository)
        
        dataSourcePopulatesMovies.execute {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let items):
                self.modules.populatesMovies = items
                self.presenter?.moviesFetched(moviesData: self.modules)
                break
            case .failure(_):
                break
            }
        }
        
        let dataSourceUpcommingMovies = UpcomingMovies(repository: repository)
        
        dataSourceUpcommingMovies.execute {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let items):
                self.modules.upcomingMovies = items
                self.presenter?.moviesFetched(moviesData: self.modules)
                break
            case .failure(_):
                break
            }
            
        }
        
        let dataSourceTopRatedMovies = TopRatedMovies(repository: repository)
        
        dataSourceTopRatedMovies.execute {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let items):
                self.modules.upcomingMovies = items
                self.presenter?.moviesFetched(moviesData: self.modules)
                break
            case .failure(_):
                break
            }
            
        }
    }
    
    func searchMovies(query: String) {
        let serviceManager = AsyncManager.shared
        let repository = MoviesRepository(serviceManagers: serviceManager)
        let searchMoviesRepo = SearchMovies(repository: repository)
        
        searchMoviesRepo.execute(query: query) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let items):
                self.modules.isFromSearch = true
                self.modules.upcomingMovies = items
                self.presenter?.moviesFetched(moviesData: self.modules)
                break
            case .failure(_):
                break
            }
            
        }
    }
}
    
 
