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
    init (serviceManagers : AsyncManagerProtocols){
        self.serviceManager = serviceManagers
    }
    
    func getPopulateMovies(completion:@escaping getMoviesItemsResponse) {
        let populateMovies = PopulateMoviesRequest()
        
        self.serviceManager.requestExecute(populateMovies) { [weak self] (dataResponse : PopulatesResponse) in
            guard let self = self else {return}
            guard let movies = dataResponse.results else {
                completion(.failure(self.error))
                return
            }
            completion(.success(movies))
        } errorCompletition: { errorString in
            completion(.failure(self.error))
        }
    }
    
    
    func getUpCommingMovies(completion:@escaping getMoviesItemsResponse) {
        
        let upcommingMoviess = UpcomingMoviesRequest()
        self.serviceManager.requestExecute(upcommingMoviess) { (dataResponse : UpcomingResponse) in
            guard let movies = dataResponse.results else {
                completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
                return
            }
            completion(.success(movies))
        } errorCompletition: { errorString in
            completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
        }
        
        
    }
    
    func getTopRatedMovies(completion:@escaping getMoviesItemsResponse){
        let topRatedRequest = TopRatedRequest()
        self.serviceManager.requestExecute(topRatedRequest) { (dataResponse : UpcomingResponse) in
            guard let movies = dataResponse.results else {
                completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
                return
            }
            completion(.success(movies))
        } errorCompletition: { errorString in
            completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
        }
    }
    
    func searchMoview(query:String, completion:@escaping getMoviesItemsResponse){
        let search = SearchRequest(searchString: query)
        
        AsyncManager.shared.requestExecute(search) { (dataResponse : SearchResponse) in
            guard let movies = dataResponse.results else {
                completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
                return
            }
            completion(.success(movies))
        } errorCompletition: { errorString in
            completion(.failure(RetrieveMoviesServiceError.ErrorGeneric))
        }
    }
}
