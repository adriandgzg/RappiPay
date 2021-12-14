//
//  Router.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation
import UIKit



class HomeRouter : HomeMoviesRouterInterface {
    var view: UIViewController?
    
    static func createModule()-> HomeView{
        
        let view = HomeView()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        
        view.presenter = presenter
        
        presenter.initVIPER(view: view, interactor: interactor, router: router)
        interactor.initVIPER(presenter: presenter)
        router.initViper(view: view)
        
        
        return view
    }
    func initViper(view:UIViewController){
        self.view = view
    }
    func goToMovieDetail(movie: MovieItem) {
        
        let detailRouter = DetailMovieRouter()
        let viewDetailModule = detailRouter.createModule()
        detailRouter.view = viewDetailModule
        if let vc  = self.view {
            detailRouter.goToDetailMovieFlow(item: movie, viewOrigin: vc )
        }
    }
        
    
}
