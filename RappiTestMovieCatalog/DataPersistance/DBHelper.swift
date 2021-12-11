

import Foundation
import SQLite3

class DBMovie : RepositoryMovieProtocol {
    func putMovie(movies: [MovieItem], categoryMovies: typeCategory) {
        
        for item in movies {
            let parseResult = item.mapToMovieDB()
            
            switch parseResult {
            case .success(let moviedb):
                let movieToInsert = MovieDB(id: moviedb.id, adult: moviedb.adult, backdrop_path: moviedb.backdrop_path, original_language: moviedb.original_language, original_title: moviedb.original_title, overview: moviedb.overview, popularity: moviedb.popularity, poster_path: moviedb.poster_path, release_date: moviedb.release_date, title: moviedb.title, video: moviedb.video, vote_average: moviedb.vote_average, vote_count: moviedb.vote_count, category: categoryMovies.rawValue)
                self.insert(movie: movieToInsert)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    func fetchMovies() -> [MovieItem] {
        let movies = read()
        
        let result = movies.map { (movie : MovieDB) -> MovieItem in
            return MovieItem(id: movie.id, adult: movie.adult, backdrop_path: movie.backdrop_path, genre_ids: [], original_language: movie.original_language, original_title: movie.original_title, overview: movie.overview, popularity: movie.popularity, poster_path: movie.poster_path, release_date: movie.release_date, title: movie.title, video: movie.video, vote_average: movie.vote_average, vote_count: movie.vote_count)
        }
        
        return result
    }
    
    init()
    {
        db = openDatabase()
        setupDatabase()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    
    
    func setupDatabase() {
        let createTableString = "CREATE TABLE IF NOT EXISTS movies(Id INTEGER PRIMARY KEY,Idmovie INTEGER,adult INTEGER,backdrop_path TEXT,original_language TEXT, original_title TEXT,overview TEXT,popularity FLOAT, poster_path TEXT,release_date TEXT,title TEXT,video INTEGER,vote_average FLOAT,vote_count INTEGER,categoryMovie TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("movies table created.")
            } else {
                print("movies table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(movie:MovieDB)
    {
        let persons = read()
        for p in persons
        {
            if p.id == movie.id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO movies (Id,Idmovie, adult, backdrop_path,original_language,original_title,overview,popularity,poster_path,release_date,title,video,vote_average,vote_count,categoryMovie) VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            //id movie
            sqlite3_bind_int(insertStatement, 1, Int32(movie.id))
            //adult
            sqlite3_bind_int(insertStatement, 2, Int32(movie.adult ? 1 : 0))
            //backdrop_path
            
            sqlite3_bind_text(insertStatement, 3, (movie.backdrop_path as NSString).utf8String, -1, nil)
            //original_language
            sqlite3_bind_text(insertStatement, 4, (movie.original_language as NSString).utf8String, -1, nil)
            //original_title
            sqlite3_bind_text(insertStatement, 5, (movie.original_title as NSString).utf8String, -1, nil)
            //overview
            sqlite3_bind_text(insertStatement, 6, (movie.overview as NSString).utf8String, -1, nil)
            //popularity
            sqlite3_bind_double(insertStatement, 7, movie.popularity)
            //poster_path
            sqlite3_bind_text(insertStatement, 8, (movie.poster_path as NSString).utf8String, -1, nil)
            //release_date
            sqlite3_bind_text(insertStatement, 9, (movie.release_date as NSString).utf8String, -1, nil)
            //title
            sqlite3_bind_text(insertStatement, 10, (movie.title as NSString).utf8String, -1, nil)
            //video
            sqlite3_bind_int(insertStatement, 11, Int32(movie.video ? 1 : 0))
            //vote_average
            sqlite3_bind_double(insertStatement, 12, movie.vote_average)
            //vote_count
            sqlite3_bind_int(insertStatement, 13,Int32(movie.vote_count))
            //categoryMovie
            sqlite3_bind_text(insertStatement, 14, (movie.category as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [MovieDB] {
        let queryStatementString = "SELECT * FROM movies;"
        var queryStatement: OpaquePointer? = nil
        var moviesArray : [MovieDB] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                
                
                //id movie
                let idmovie = sqlite3_column_int(queryStatement,1)
                //adult
                let adult = sqlite3_column_int(queryStatement, 2)
                //backdrop_path
                let backdrop_path = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let original_language = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let original_title = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let overview = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let popularity = sqlite3_column_double(queryStatement, 7)
                let poster_path = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                
                let release_date = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let video = sqlite3_column_int(queryStatement, 11)
                
                let vote_average = sqlite3_column_double(queryStatement, 12)
                
                let vote_count = sqlite3_column_int(queryStatement, 13)
                
                let categoryMovie = String(describing: String(cString: sqlite3_column_text(queryStatement, 14)))
                
                                          moviesArray.append(MovieDB(id: Int(idmovie), adult: adult == 0 ? false : true, backdrop_path: backdrop_path, original_language: original_language, original_title: original_title, overview: overview, popularity: popularity, poster_path: poster_path, release_date: release_date, title: title, video: video == 0 ? false : true, vote_average: vote_average, vote_count: Int(vote_count), category: categoryMovie))
                print("Query Result:")
                print("\(idmovie) | \(title) | \(release_date)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return moviesArray
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM movies WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
