//
//  OflineRepositoryTest.swift
//  RappiTestMovieTests
//
//  Created by Adrian Dominguez Gómez on 08/12/21.
//

import Foundation

import XCTest

class MoviesOflineTest : XCTestCase {
    var cacheOfline = DBMovie()
    let itemID = 4009
    var movie = MovieItem(id: 4009, adult: false, backdrop_path: nil, genre_ids: nil, original_language: nil, original_title: nil, overview: nil, popularity: nil, poster_path: nil, release_date: nil, title: nil, video: nil, vote_average: nil, vote_count: nil)
    
    
    func test_addMovies(){
        
        let movies = self.cacheOfline.fetchMovies()
        let count = movies.count
        movie.id = movie.id! + movies.count //new id aleatory
        self.cacheOfline.putMovie(movies: [movie], categoryMovies: .PopularItems)
        let arrayAfterPut = self.cacheOfline.fetchMovies()
        
        
        XCTAssertEqual(count + 1, arrayAfterPut.count)
    }
    
    func test_AddTwoTimeSameMovieInCache(){
        let movies = self.cacheOfline.fetchMovies()
        let count = movies.count
        
        self.cacheOfline.putMovie(movies: [movie], categoryMovies: .PopularItems)
        self.cacheOfline.putMovie(movies: [movie], categoryMovies: .PopularItems)
        self.cacheOfline.putMovie(movies: [movie], categoryMovies: .PopularItems)
        self.cacheOfline.putMovie(movies: [movie], categoryMovies: .PopularItems)
        
        let arrayAfterPut  = self.cacheOfline.fetchMovies()
        
        XCTAssertEqual(count, arrayAfterPut.count)
    }
}
