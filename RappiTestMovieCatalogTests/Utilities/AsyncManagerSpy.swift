//
//  AsyncManagerSpy.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 09/12/21.
//

import Foundation
import Alamofire
import ObjectMapper

class AsyncManagerStub:AsyncManagerProtocols{
    let failResponte : Bool
    var expectApiResponse:String? = nil
    var nameFile :String = ""
    init(shouldFail:Bool){
        self.failResponte = shouldFail
    }
    func requestExecute<T>(_ serviceConfig: RequestProtocol, completion: @escaping (T) -> Void, errorCompletition: @escaping (String) -> Void) where T : Mappable {
        if failResponte {
            errorCompletition(messagesGeneric.error)
        }else{
            guard let statuses = Mapper<T>().map(JSONString: expectApiResponse!) else {
                print("Error")
                errorCompletition(messagesGeneric.error)
                return
                
            }
            completion(statuses)
            
        }
        
    }
    func set(apiResponseFileName:String){
        self.nameFile  = apiResponseFileName
        expectApiResponse = readLocalFile(forName: apiResponseFileName)
    }
    
    private func readLocalFile(forName name: String) -> String? {
      
        guard let bundlePath = Bundle.main.path(forResource: name,
                                                ofType: "json") else {
            print("error bundle")
            return nil   }
        
        do {
            let jsonString = try String(contentsOfFile: bundlePath)
            return jsonString
        }catch{
            print("Fail")
        }
        
        return nil
    }
    
}
