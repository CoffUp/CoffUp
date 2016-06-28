//
//  FoursquareProxy.swift
//  CoffUp
//
//  Created by Roderic on 6/23/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation
import QuadratTouch

typealias JSONParameters = [String: AnyObject]

class FoursquareProxy {
    let configuration : Configuration
    let session : Session
    
    init() {
        let client = Client(clientID:       "OKMDH0JUFBASD2OGF5JFTRMR3BNA25UMPHDK0IULTH2B455B",
                            clientSecret:   "XY50ZJURLMHLRHYJ0ZMTFSEKWU1CBLPGXBW2SADYFBTW5EYB",
                            redirectURL:    "testapp123://foursquare")
        configuration = Configuration(client:client)
        Session.setupSharedSessionWithConfiguration(configuration)
        session = Session.sharedSession()
    }
    
    func getVenueWith(identifier: String, completion: (Venue?, NSError?) -> Void) {
        let venueTask = session.venues.get(identifier) { (result) in
            if let error = result.error {
                completion(nil, error)
                return
            }
            
            // Get the relevant Venue data from the response
            guard let venue = Venue(venue: result.response!["venue"] as! [String: AnyObject]) else {
                let error = self.errorWithCode(9999, localizedString: "Error parsing JSON")
                completion(nil, error)
                return
            }
            completion(venue, nil)
        }
        venueTask.start()
    }
    
    func searchVenueWithString(query: String, completion: ([Venue]?, NSError?) -> Void) {
        var parameters = [Parameter.query:query]
        // TODO pretty hard coded here
        parameters += [Parameter.near:"San Francisco, CA"]
        let searchTask = session.venues.search(parameters) { (result) in
            // Example search results https://api.foursquare.com/v2/venues/search?near=San%20Francisco%20CA&query=Blue%20Bottle&oauth_token=3X1I0CULTT2GPRL10UHVIFNJUVNWLAPS5CZYP0OJXX5RV4YW&v=20160623
            guard let responseDict = result.response else {
                let error = self.errorWithCode(9998, localizedString: "Invalid JSON, did not include an array of Venues")
                completion(nil, error)
                return
            }

            guard let venuesArray = responseDict["venues"] as! [JSONParameters]? else {
                let error = self.errorWithCode(9997, localizedString: "Invalid JSON, did not include venue objects")
                completion(nil, error)
                return
            }
            
            var ret = [Venue]()
            for venueJSON in venuesArray {
                if let venue = Venue(venue: venueJSON) {
                    ret.append(venue)
                } else {
                    let error = self.errorWithCode(9999, localizedString: "Error parsing JSON")
                    completion(nil, error)
                }
            }
            completion(ret, nil)
        }
        searchTask.start()
    }
    
    func errorWithCode(errorCode: Int, localizedString: String) -> NSError {
        return NSError(domain: "io.thumbworks.coffup", code: errorCode, userInfo: [NSLocalizedDescriptionKey: localizedString])
    }
}