//
//  SearchMovies.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 09/12/21.
//

import UIKit
import Alamofire

class SearchMovies: MoviesResponseProtocol {
    var query:String = ""

    let asyncManager = AsyncManager.shared
    let repository :MoviesRepository
    
    init(repository:MoviesRepository){
        self.repository = repository
    }
    func execute(query:String,completion: @escaping getMoviesItemsResponse) {
        self.query = query
        self.execute { res in
                completion(res)
        }
    }
    func execute(completion: @escaping getMoviesItemsResponse) {
        repository.searchMoview(query: query) { result in
            completion(result)
        }
    }
    
}
