//
//  PopuparMovies.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 09/12/21.
//

import UIKit
import Alamofire

protocol MoviesResponseProtocol {
    func execute(completion: @escaping getMoviesItemsResponse)
}

class PopuparMovies: MoviesResponseProtocol {
    let asyncManager = AsyncManager.shared
    let repository :MoviesRepository
    
    init(repository:MoviesRepository){
        self.repository = repository
    }
    func execute(completion: @escaping getMoviesItemsResponse) {
        repository.getPopulateMovies { result in
            completion(result)
        }
    }
}
