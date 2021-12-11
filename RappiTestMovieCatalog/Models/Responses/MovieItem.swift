import Foundation
import ObjectMapper

struct MovieItem : Mappable {
	var adult : Bool?
	var backdrop_path : String?
	var genre_ids : [Int]?
	var id : Int?
	var original_language : String?
	var original_title : String?
	var overview : String?
	var popularity : Double?
	var poster_path : String?
	var release_date : String?
	var title : String?
	var video : Bool?
	var vote_average : Double?
	var vote_count : Int?

	init?(map: Map) {

	}
    
    init(id : Int?,adult:Bool,backdrop_path : String?, genre_ids : [Int]?,original_language : String?,original_title : String?,overview : String?,popularity : Double?,poster_path : String?,release_date:String?,title:String?,video : Bool?,vote_average : Double?,vote_count : Int?){
        self.id = id
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.genre_ids = genre_ids
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }

	mutating func mapping(map: Map) {

		adult <- map["adult"]
		backdrop_path <- map["backdrop_path"]
		genre_ids <- map["genre_ids"]
		id <- map["id"]
		original_language <- map["original_language"]
		original_title <- map["original_title"]
		overview <- map["overview"]
		popularity <- map["popularity"]
		poster_path <- map["poster_path"]
		release_date <- map["release_date"]
		title <- map["title"]
		video <- map["video"]
		vote_average <- map["vote_average"]
		vote_count <- map["vote_count"]
	}
    
    func mapToMovieDB()-> Result<MovieDB,Error> {
        if let idm = self.id {
            
            let movie = MovieDB(id: idm,
                                adult: self.adult ?? false,
                                backdrop_path: self.backdrop_path ?? "",
                                original_language: self.original_language ?? "",
                                original_title: self.original_title ?? "",
                                overview: self.overview ?? "",
                                popularity: self.popularity ?? 0.0,
                                poster_path: self.poster_path ?? "",
                                release_date: self.release_date ?? "",
                                title: self.title ?? "",
                                video: self.video ?? false,
                                vote_average: self.vote_average ?? 0.0, vote_count: self.vote_count ?? 0, category:"default")
            
            return .success(movie)
        }
        
        return .failure(RetrieveMoviesServiceError.ErrorGeneric)
    }

}
