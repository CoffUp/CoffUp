//
//  Event.swift
//  CoffUp
//
//  Created by Roderic on 6/23/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation

class Event {
    let date: NSDate
    let foursquareID: String
    var venue: Venue?
    
    init(newFoursquareID : String, newDate: NSDate) {
        date = newDate
        foursquareID = newFoursquareID
    }
}