//
//  ViewController.swift
//  RappiTestMovieCatalog
//
//  Created by Adrian Dominguez Gómez on 29/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let serviceManager = AsyncManager.shared
        let repository = MoviesRepository(serviceManagers: serviceManager)
        let search = SearchMovies(repository: repository)
        search.execute(query: "taken") { res in
            dump(res)
        }
    }


}

