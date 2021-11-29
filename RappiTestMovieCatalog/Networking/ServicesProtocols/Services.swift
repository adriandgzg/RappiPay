

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


open class AsyncManager : NSObject{
    
    public static let shared = AsyncManager()
    
   let sessionManager = Alamofire.SessionManager()
    public var backentProtocol  = "https://"
    public var backentHost =  "www.themealdb.com/api/json/v1/1/"
   
    
    
    
    var blockRetry : blckChangeHeader? = nil
    var saverHeader:Bool = false
    var requestRetry: RequestProtocol? = nil

   public override init() {
        super.init()
        backentProtocol  = "https://"
        backentHost      =  "www.themealdb.com/api/json/v1/1/"
    }
    
   public func setRequestForRetry(request:RequestProtocol?){
        self.requestRetry = request
    }
    
    func getRequestForRetry()-> RequestProtocol? {
        return self.requestRetry
    }
    
    open func setRetryBlock(bloque: @escaping blckChangeHeader ){
        blockRetry = bloque
    }
    open func setHost(host:String, backendProtocol: String){
        
        self.backentProtocol = backendProtocol
        self.backentHost = host
    }
  
    
}


extension AsyncManager {
    
    open func requestExecute<T:Mappable>(_ serviceConfig:RequestProtocol,validateHeader : Bool = false, numberRetry: Int = 0, completion:@escaping (_ dataResponse:T) -> Void, errorCompletition: @escaping (_ errorString:String) -> Void){
        
        var url = self.composeEnvironment(strURL: serviceConfig.getUrl())
        
        if let params = serviceConfig.getQueryParams() {
            url = self.createQueryParameters(params: params, url: url)
        }
        if let replaceKeys = serviceConfig.getReplaceKeys() {
            url = self.replaceKeysinURL(strUrl: url, params: replaceKeys)
        }
        
        let type:HTTPMethod = serviceConfig.getMethod()
        
        var parameters = Parameters()
        if let params = serviceConfig.getParameters(){
             parameters = params
        }
        
        var headers : [String:String] = ["Content-Type":"application/x-www-form-urlencoded"]

             
        
        if let head = serviceConfig.getHeaders() {
             headers = head
        }
        
        sessionManager.request(url,method: type, parameters: parameters, encoding:URLEncoding.default, headers: headers ).responseObject { (response: DataResponse<T>) in
            if response.result.isSuccess{
                
                let responseService = response.result.value
                completion(responseService!)
            } else {
                errorCompletition((response.result.error?.localizedDescription)!)
            }
        }
    }


   
    
    func composeEnvironment(strURL:String)-> String{
       
        let url =  "\(self.backentProtocol)\(self.backentHost)\(strURL)"
        
        return url
    }
    func createQueryParameters(params: Parameters, url:String)-> String{
        // let params = ["pdpID":"12312312"]
        
        if params.count == 0  {
            
            return url
        }
        var queryItems : [NSURLQueryItem] =  [NSURLQueryItem]()
        
        for item in params {
            if let strValue: String = item.value as? String{
                queryItems.append(NSURLQueryItem(name: item.key, value: strValue))
            }
        }
        
        let urlComps = NSURLComponents(string: url)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url?.absoluteString
        
      
        return URL ?? url
    }
    /// Metodo genérico para hacer cualquier tipo de petición GET sin parametros
    class func getRequestExecute<T:Mappable>(_ type:RequestProtocol , completion:@escaping (_ dataResponse:T) -> Void, errorCompletition: @escaping (_ errorString:String) -> Void){
        
        let url = type.getUrl()
        
        
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<T>) in
            
            if response.result.isSuccess{
                let responseService = response.result.value
                completion(responseService!)
            } else {
                errorCompletition((response.result.error?.localizedDescription)!)
            }
        }
    }
      
    func replaceKeysinURL(strUrl: String, params : Parameters) -> String
    {
        var strfinal = strUrl
        for item in params{
           strfinal =  strfinal.replacingOccurrences(of: item.key, with: item.value as! String)
        }
        return strfinal
    }
}

