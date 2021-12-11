//
//  TopRatedResponse.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 02/12/21.
//

import Foundation
import ObjectMapper

struct TopRatedResponse : Mappable {
    var dates : Dates?
    var page : Int?
    var results : [MovieItem]?
    var total_pages : Int?
    var total_results : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        dates <- map["dates"]
        page <- map["page"]
        results <- map["results"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }

}
