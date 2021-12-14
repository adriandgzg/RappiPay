//
//  MovieDetailView.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 13/12/21.
//

import UIKit

protocol DetailViewInterface:AnyObject {
    func showMoviesData(movieData: MovieItem)
}

class MovieDetailView: UIViewController , DetailViewInterface {
   
    
    
    var item:MovieItem?
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var titleMovie: UIView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var aditionalData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateView()
    }
    func updateView(){
        guard let pathImage = item?.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500" + pathImage) else { return }
        self.imageMovie.af_setImage(withURL:url)
        
        lblTitle.text = item?.title ?? ""
        overview.text = item?.overview ?? ""
        var aditionalValues = ""
        if let popularity  = item?.popularity {
            aditionalValues = "Popularidad " + String(popularity) + "\n"
        }
        if let releaseDate = item?.release_date {
            aditionalValues = aditionalValues + "Fecha de estreno " + releaseDate + "\n"
        }
        if let originalLenguaje = item?.original_language {
            aditionalValues = aditionalValues + "Lenguaje Original" + originalLenguaje + "\n"
        }
        
        self.aditionalData.text  = aditionalValues
        
    }
    
    func showMoviesData(movieData: MovieItem) {
        self.item = movieData
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
