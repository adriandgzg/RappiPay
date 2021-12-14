//
//  HomePresenter.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation

class HomePresenter : HomeMoviesModuleInterface {
     var view: HomeViewInterface?
     var interactor: HomeMoviesInteractorInput?
     var router : HomeMoviesRouterInterface?

    func initVIPER(view:HomeViewInterface, interactor:HomeMoviesInteractorInput, router: HomeMoviesRouterInterface){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        self.interactor?.fetchMovies()
    }
    
    func showDetailsForMovie(movieData: MovieItem) {
        self.router?.goToMovieDetail(movie:movieData)
    }
}

extension HomePresenter: HomeMoviesInteractorOutput {
    func moviesFetched(moviesData: HomeModel) {
      
        self.view?.showMoviesData(moviesData: moviesData)
    }
    
    func searchFetchet(moviesData: HomeModel) {
        self.view?.showMoviesData(moviesData: moviesData)
    }
    
    
}
