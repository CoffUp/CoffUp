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
        
        self.title = "CoffUp SF"
        
        let fetcher = EventFetcher()
        self.dateLabel.text = ""
        self.nameLabel.text = ""
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
            }
        }
    }
}

