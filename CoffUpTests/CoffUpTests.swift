//
//  CoffUpTests.swift
//  CoffUpTests
//
//  Created by Roderic on 6/22/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import XCTest
import Mockingjay

@testable import CoffUp

extension CoffUpTests {
    func searchMatcher(request: NSURLRequest) -> Bool {
        return (request.URL?.absoluteString.containsString("testsearchstring"))!
    }
    
    func clintonMatcher(request: NSURLRequest) -> Bool {
        return (request.URL?.absoluteString.containsString("clintonBakery"))!
    }
}

class CoffUpTests: XCTestCase {
    let foursquare = FoursquareProxy()

    override func setUp() {
        super.setUp()
        
        let searchPath = NSBundle(forClass: self.dynamicType).pathForResource("searchVenues", ofType: "json")!
        let searchData = NSData(contentsOfFile: searchPath)!
        stub(searchMatcher, builder: jsonData(searchData))
        
        let venuePath = NSBundle(forClass: self.dynamicType).pathForResource("getVenue", ofType: "json")!
        let venueData = NSData(contentsOfFile: venuePath)!
        stub(clintonMatcher, builder: jsonData(venueData))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseVenueFetch() {
        let expectation = expectationWithDescription("getVenue expectation")
        foursquare.getVenueWith("clintonBakery") { (result) in
            print(result)
            switch result {
            case .Failure(_):
                XCTFail()
            case .Success(let venue):
                XCTAssertEqual(venue.name, "Clinton St. Baking Co. & Restaurant")
                XCTAssertEqual(venue.foursquareID, "40a55d80f964a52020f31ee3")
                XCTAssertEqual(venue.crossStreet, "at E Houston St")
                XCTAssertEqual(venue.coordinate.latitude, 40.721079247682162)
                XCTAssertEqual(venue.coordinate.longitude, -73.983942568302155)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            print("error is ", error)
        }
    }
    
//    func testParseVenueSearch() {
//        let expectation = expectationWithDescription("searchVenue expectation")
//        foursquare.searchVenueWithString("testsearchstring") { (result) in
//            switch result {
//            case .Failure(_):
//                XCTFail()
//            case .Success(let venues):
//                XCTAssertEqual(venues.count, 30)
//                XCTAssertEqual(venues[0].name, "Blue Bottle Coffee")
//                XCTAssertEqual(venues[0].foursquareID, "43d3901ef964a5201f2e1fe3")
//            }
//            expectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(1000) { (error) in
//            print("error is ", error)
//        }
//    }
}
