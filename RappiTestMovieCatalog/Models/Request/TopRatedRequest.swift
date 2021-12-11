//
//  TopRatedRequest.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 02/12/21.
//

import Foundation
import Alamofire
class TopRatedRequest: RequestProtocol {
    func getQueryParams() -> Parameters? {
        return nil
    }
    
    func getParameters() -> Parameters? {
        return nil
    }
    
    func getUrl() -> String {
        return stockURL.topRated
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
