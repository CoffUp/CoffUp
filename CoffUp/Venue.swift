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
    let imageURL: NSURL?
    var coordinate: CLLocationCoordinate2D

    init(venueName: String, latitude: Double, longitude: Double, imageURLString: String) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        name = venueName
        imageURL = NSURL(string: imageURLString)
    }

}