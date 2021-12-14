//
//  Router.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 13/12/21.
//

import Foundation
import UIKit
protocol DetailMovieRouterInterface {
    func createModule()-> MovieDetailView
    func goToDetailMovieFlow(item:MovieItem, viewOrigin:UIViewController)
    
}

class DetailMovieRouter: DetailMovieRouterInterface {
    var view:MovieDetailView?

    func createModule()-> MovieDetailView{
        
        let view = MovieDetailView()
        let router = DetailMovieRouter()
        router.view = view
        
        
        return view
    }
    
    func goToDetailMovieFlow(item:MovieItem, viewOrigin:UIViewController){
        self.view?.showMoviesData(movieData: item)
        if let viewDest = self.view {
            viewOrigin.navigationController?.pushViewController(viewDest, animated: true)
        }
        
    }
}
