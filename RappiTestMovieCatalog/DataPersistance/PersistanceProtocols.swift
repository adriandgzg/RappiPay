//
//  PersistanceProtocols.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 08/12/21.
//

import Foundation

protocol RepositoryMovieProtocol{
    func putMovie(movies:[MovieItem], categoryMovies:typeCategory)
    func setupDatabase()
    func fetchMovies() -> [MovieItem]
}
