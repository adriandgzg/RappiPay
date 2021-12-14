//
//  Abstracts.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation
import UIKit
public class SectionLanding {
    
    public typealias typeSection = String
    
    public var id: String = ""
    public var type: typeSection = ""
    public var status: StatusSection = .firstLoad
    public var parameter: Any?
    public var data: Any? {
        didSet {
            if self.data == nil {
                self.status = .firstLoad
            }else {
                self.status = .loadedData
            }
        }
    }
    public var contentOfset: CGPoint = .zero
    
    public enum StatusSection {
        case firstLoad
        case failedService
        case loadedData
        case loadingData
    }
}


public struct BannerSection {
    public var id:String
    public var name: String
    public var image: String
    public var background: String
    public var icon: String
    public var type: TypeAction = .none
    public var parameter: String
    
    public enum TypeAction: String, Codable {
        case image
        case none
    }

}

public struct Theme {
    static let backgroundColor: UIColor = UIColor(named: "backgroundColor") ?? UIColor()
    public static let primaryColor: UIColor = UIColor(named: "PrimaryColor") ?? UIColor()
    public static let buttonColor: UIColor = UIColor(named: "buttonsColor") ?? UIColor()
    public static let textMainColor: UIColor = UIColor(named: "TextMainColor") ?? UIColor()
    static let textPrimaryColor: UIColor = UIColor(named: "TextPrimaryColor") ?? UIColor()
    static let TextSecundaryColor: UIColor = UIColor(named: "TextSecundaryColor") ?? UIColor()
    static let lightGray: UIColor = UIColor(named: "lightGray") ?? UIColor()
    static let washedRed: UIColor = UIColor(named: "washedRed") ?? UIColor()
}



public struct Banner: Codable {
    public let title: String?
    public var image: String?
    public let id: String?
}
