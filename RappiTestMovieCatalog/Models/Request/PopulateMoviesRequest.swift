//
//  RequestPopulateMovies.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 30/11/21.
//

import Alamofire
import UIKit

class PopulateMoviesRequest: RequestProtocol {
    func getQueryParams() -> Parameters? {
        return nil
    }
    
    func getParameters() -> Parameters? {
        return nil
    }
    
    func getUrl() -> String {
        return stockURL.popularsMovies
    }
    
    func getReplaceKeys() -> Parameters? {
        return nil
    }
    
    func getHeaders() -> [String : String]? {
        return nil
    }
    
    func getMethod() -> HTTPMethod {
        return .get
    }
    

}
