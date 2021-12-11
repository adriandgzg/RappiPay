//
//  SceneDelegate.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 29/11/21.
//
import UIKit
import Alamofire
import AlamofireObjectMapper

public protocol  RequestProtocol {
    
      func getQueryParams() -> Parameters?
      func getParameters()->Parameters? //validar para que tambien reciba un json
      func getUrl() -> String
      func getReplaceKeys()->Parameters?
      func getHeaders()-> [String:String]?
      func getMethod() -> HTTPMethod
}

