//
//  RequestMoviesTest.swift
//  RappiTestMovieCatalogTests
//
//  Created by Adrian Dominguez Gómez on 08/12/21.
//

import XCTest

class RequestPopularMoviesTest: XCTestCase {
    var requestManager = AsyncManagerStub(shouldFail: true)
    
    func test_invoqueRequestWIthFailResponse(){
        let waiforGetMoviesPopular = expectation(description: "Expectation fail response")
        let reposutory = MoviesRepository(serviceManagers: requestManager)
        var errorString: String? = nil
        reposutory.getPopulateMovies { result in
            switch result {
            case .success(_):
                waiforGetMoviesPopular.fulfill()
                break
            case .failure(let error):
                errorString = error.localizedDescription
                waiforGetMoviesPopular.fulfill()
                break
            }
        }
        waitForExpectations(timeout: 1) { _ in
        XCTAssertNotNil(errorString)
        }
    }
    
    func testWhenSuccesResponse(){
        let waiforGetMoviesPopular = expectation(description: "Expectation succes response")
        requestManager = AsyncManagerStub(shouldFail: false)
        requestManager.set(apiResponseFileName: "SuccesResponse")
        let reposutory = MoviesRepository(serviceManagers: requestManager)
        var succes = false
        
        reposutory.getPopulateMovies { result in
            switch result {
            case .success(_):
                succes = true
                waiforGetMoviesPopular.fulfill()
                break
            case .failure(_):
                
                waiforGetMoviesPopular.fulfill()
                break
            }
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(succes)
        }
    }
}

