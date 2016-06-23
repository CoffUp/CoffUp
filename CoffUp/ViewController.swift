//
//  ViewController.swift
//  CoffUp
//
//  Created by Roderic on 6/22/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetcher = EventFetcher()
        self.dateLabel.text = ""
        self.nameLabel.text = ""
        
        // Uncomment this to add an event a few hours in the future
//        fetcher.addEvent("4d065736a26854819660c1bd", date: NSDate().dateByAddingTimeInterval(10000))
        
        fetcher.getNextEvent { (event, error) in
            if let error = error {
                // TODO obviously handle the error cases
                print("we got an error", error)
            }
            else if let event = event {
                               let proxy = FoursquareProxy.init()
                proxy.getVenueWith(event.foursquareID, completion: { (venue, error) in
                    if let error = error {
                        // TODO obviously handle the error cases
                        print("we got an error", error)
                    } else if let venue = venue {
                        print("venue is ", venue)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.dateLabel.text = event.date.shortFormat()
                            self.nameLabel.text = venue.name
                            self.map.addAnnotation(venue)
                            self.map.showAnnotations(self.map.annotations, animated: true)
                        })
                    }
                })
                
                // Just trying out doing a search. 
                proxy.searchVenueWithString("Blue Bottle", completion: { (venues, error) in
                    if let error = error {
                        // TODO obviously handle the error cases
                        print("error when searching", error)
                    }
                    if let venues = venues {
                        // TODO Probably show the list of results and add a timestamp (Some Wednesday at 8:30AM in the future) to the selection, then send it to the Clouds
                        print("Venues ", venues)
                    }
                })
            }
        }
    }
}

