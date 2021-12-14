//
//  SceneDelegate.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 29/11/21.
//
import Foundation
import UIKit
public typealias blckChangeHeader = () -> (user:String, psw:String)

public struct stockURL {
    static let popularsMovies    = "/movie/popular"
    static let upcomingMovies    = "/movie/upcoming"
    static let topRated          = "/movie/top_rated"
    static let search            = "/search/movie"
}


struct constants{
    
    static let bearerKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjODlmOTk3YjlmODA1ZDc4M2M4MWZjMWU4NTRlZDdkMSIsInN1YiI6IjYxOTZiYTkyYmMyY2IzMDA0Mjc4M2U0NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.n6hXlqHR9Fv4hHi_j3pZC0oJoKq8hJrU-owQodEkocQ"
}


struct RetrieveMoviesServiceError {
    static let ErrorGeneric = NSError(domain: "ErrorGeneric", code: 9000, userInfo: nil)
}

public struct messagesGeneric{
    
    static let error = "No se pudo completar la operación"
}
enum Section: String {
    case populars = "Populares"
    case Upcoming = "Proximamente"
    case TopRated = "Top Ranking"

}
    



public var contentOfset: CGPoint = .zero
