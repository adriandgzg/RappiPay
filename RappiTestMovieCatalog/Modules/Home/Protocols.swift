//
//  Protocols.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation
protocol HomeViewInterface: AnyObject {
    func showMoviesData(moviesData: HomeModel)
    func showNoContentScreen()
}


protocol HomeMoviesModuleInterface: AnyObject {
   func updateView()
   func showDetailsForMovie(movieData:MovieItem)
}

protocol  HomeMoviesInteractorOutput: AnyObject {
    func moviesFetched(moviesData:HomeModel)
    func searchFetchet(moviesData:HomeModel)
}


protocol HomeMoviesInteractorInput: AnyObject {
    func fetchMovies()
    func searchMovies(query:String)
}

protocol HomeMoviesRouterInterface:AnyObject{
    func goToMovieDetail(movie:MovieItem)
}

protocol didSelectMoviesProtocol :AnyObject {
    func didSelectMovies(item:MovieItem)
}
