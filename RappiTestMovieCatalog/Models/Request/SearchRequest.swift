//
//  SearchRequest.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 07/12/21.
//

import Foundation
import Alamofire
class SearchRequest: RequestProtocol {
    var search: String
    
    
    init(searchString:String){
        self.search = searchString
    }
    func getQueryParams() -> Parameters? {
        return ["query": search]
    }
    
    func getParameters() -> Parameters? {
        return nil
    }
    
    func getUrl() -> String {
        return stockURL.search
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
