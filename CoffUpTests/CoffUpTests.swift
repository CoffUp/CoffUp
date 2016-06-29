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

class CoffUpTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let path = NSBundle(forClass: self.dynamicType).pathForResource("getVenue", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(clintonMatcher, builder: jsonData(data))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func clintonMatcher(request:NSURLRequest) -> Bool {
        return (request.URL?.absoluteString.containsString("clintonBakery"))!
    }
    
    func testParseVenueFetch() {
        let expectation = expectationWithDescription("getVenue expectation")
        let foursquare = FoursquareProxy()
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
        
        print("let's wait")
        self.waitForExpectationsWithTimeout(10) { (error) in
            print("error is ", error)
        }
        print("we got it")
    }
}
