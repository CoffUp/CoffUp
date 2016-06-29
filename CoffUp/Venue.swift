//
//  Venue.swift
//  CoffUp
//
//  Created by Roderic on 6/23/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation
import MapKit

class Venue: NSObject, MKAnnotation  {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let foursquareID: String
    let crossStreet: String?
    init(foursquareID: String, venueName: String, latitude: Double, longitude: Double, crossStreet:String?) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.name = venueName
        self.foursquareID = foursquareID
        self.crossStreet = crossStreet
    }
}

extension Venue {
    convenience init!(venue: [String: AnyObject]) {
        guard let name = venue["name"] as! String?,
        lat = venue["location"]!["lat"] as! Double?,
        lon = venue["location"]!["lng"] as! Double?,
        foursquareID = venue["id"] as! String? else {
            return nil
        }
        // The optional yet helpful cross street
        let cross = venue["location"]!["crossStreet"] as! String?
        self.init(foursquareID: foursquareID, venueName: name, latitude: lat, longitude: lon, crossStreet: cross)
    }
}