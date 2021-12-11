//
//  UpcomingMovies.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 09/12/21.
//

import UIKit


class UpcomingMovies: MoviesResponseProtocol {
    let asyncManager = AsyncManager.shared
    let repository :MoviesRepository
    
    init(repository:MoviesRepository){
        self.repository = repository
    }
    func execute(completion: @escaping getMoviesItemsResponse) {
        repository.getUpCommingMovies { result in
            completion(result)
        }
    }
}
