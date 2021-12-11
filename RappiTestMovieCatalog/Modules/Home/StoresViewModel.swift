//
//  Stores.swift
//  cencosud.supermercados
//
//  Created by Luis Barrios on 3/8/21.
//

import Foundation
import RxSwift
import CencosudNetworking
import CencosudMobileCore


class StoresViewModel {
    
    var branches:[Branch]?
    
    
  
    func getStores() -> Observable<([Branch])>{
        return Observable.create{ observer in
            SalesChannelApiManager().getStores{
                (Branches, error) in
                if error != nil {
                    observer.onError(error!)
                }

                if Branches == nil {
                    observer.onError(NetworkingError.generic)
                }else {
                    self.branches = Branches
                    observer.onNext(Branches!)
                    }
                
                observer.onCompleted()
                }
                
                return Disposables.create()
            }
           
        }
    
    
    
}
