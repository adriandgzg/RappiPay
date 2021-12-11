//
//  TopRatedMovies.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 09/12/21.
//

import UIKit

class TopRatedMovies: MoviesResponseProtocol {
    let asyncManager = AsyncManager.shared
    let repository :MoviesRepository
    
    init(repository:MoviesRepository){
        self.repository = repository
    }
    func execute(completion: @escaping getMoviesItemsResponse) {
        repository.getTopRatedMovies { result in
            completion(result)
        }
    }
}
