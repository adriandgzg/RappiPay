//
//  MoviesRepository.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 07/12/21.
//

import Foundation


typealias getMoviesItemsResponse = (Result<[MovieItem], Error>) -> Void

class MoviesRepository {
    let serviceManager : AsyncManagerProtocols
    let error = RetrieveMoviesServiceError.ErrorGeneric
    let dbOfline = DBMovie()
    init (serviceManagers : AsyncManagerProtocols){
        self.serviceManager = serviceManagers
    }
    
    func getPopulateMovies(completion:@escaping getMoviesItemsResponse) {
        let populateMovies = PopulateMoviesRequest()
        
        self.serviceManager.requestExecute(populateMovies) { [weak self] (dataResponse : PopulatesResponse) in
            guard let self = self else {return}
            guard let movies = dataResponse.results else {
                let itemsOfline = self.dbOfline.fetchMovies(category: .PopularItems)
                completion(.success(itemsOfline))
                return
            }
           
            self.dbOfline.putMovie(movies: movies, categoryMovies: .PopularItems)
            completion(.success(movies))
            
        } errorCompletition: { errorString in
            let itemsOfline = self.dbOfline.fetchMovies(category: .PopularItems)
            completion(.success(itemsOfline))
        }
    }
    
    
    func getUpCommingMovies(completion:@escaping getMoviesItemsResponse) {
        
        let upcommingMoviess = UpcomingMoviesRequest()
        self.serviceManager.requestExecute(upcommingMoviess) { (dataResponse : UpcomingResponse) in
            guard let movies = dataResponse.results else {
                let itemsOfline = self.dbOfline.fetchMovies(category: .upcomming)
                completion(.success(itemsOfline))
                return
            }
          
            self.dbOfline.putMovie(movies: movies, categoryMovies: .upcomming)
            completion(.success(movies))
            
         
        } errorCompletition: { errorString in
            let itemsOfline = self.dbOfline.fetchMovies(category: .upcomming)
            completion(.success(itemsOfline))
        }
        
        
    }
    
    func getTopRatedMovies(completion:@escaping getMoviesItemsResponse){
        let topRatedRequest = TopRatedRequest()
        self.serviceManager.requestExecute(topRatedRequest) { (dataResponse : TopRatedResponse) in
            guard let movies = dataResponse.results else {
                let itemsOfline = self.dbOfline.fetchMovies(category: .topRated)
                completion(.success(itemsOfline))
                return
            }
            
            self.dbOfline.putMovie(movies: movies, categoryMovies: .topRated)
            completion(.success(movies))
            
        } errorCompletition: { errorString in
            //completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
            let itemsOfline = self.dbOfline.fetchMovies(category: .topRated)
            completion(.success(itemsOfline))
        }
    }
    
    func searchMoview(query:String, completion:@escaping getMoviesItemsResponse){
        let search = SearchRequest(searchString: query)
        print(query)
        AsyncManager.shared.requestExecute(search) { (dataResponse : SearchResponse) in
            guard let movies = dataResponse.results else {
                let itemsOfline = self.dbOfline.fetchMovies(category: .all)
                completion(.success(itemsOfline))
                return
            }
            print(movies)
            completion(.success(movies))
        } errorCompletition: { errorString in
            
            let itemsOfline = self.dbOfline.fetchMovies(category: .all)
            completion(.success(itemsOfline))
        }
    }
}
