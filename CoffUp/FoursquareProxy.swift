//
//  FoursquareProxy.swift
//  CoffUp
//
//  Created by Roderic on 6/23/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation
import QuadratTouch

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
            print(result)
            if let error = result.error {
                print("error is", error)
                return
            }
            
            // Get the relevant Venue data from the response
            if let venue = result.response!["venue"] {
                print("venue is ", venue)
                if let name = venue["name"]! as! String?, lat = venue["location"]?!["lat"] as! Double?, lon = venue["location"]?!["lng"] as! Double?  {
                    print("name", name, "lat", lat, "lon", lon)
                    completion(Venue(venueName: name, latitude: lat, longitude: lon, imageURLString: "hi"), nil)
                }
            }
        }
        venueTask.start()
    }
    
    func searchVenueWithString(query: String, completion: ([Venue]?, NSError?) -> Void) {
        var parameters = [Parameter.query:query]
        // TODO pretty hard coded here
        parameters += [Parameter.near:"San Francisco, CA"]
        let searchTask = session.venues.search(parameters) { (result) in
            // TODO parse out the responses into an array of venues and pass them to the completion handler
            // Example search results https://api.foursquare.com/v2/venues/search?near=San%20Francisco%20CA&query=Blue%20Bottle&oauth_token=3X1I0CULTT2GPRL10UHVIFNJUVNWLAPS5CZYP0OJXX5RV4YW&v=20160623
            print(result)
        }
        
        searchTask.start()
    }
}