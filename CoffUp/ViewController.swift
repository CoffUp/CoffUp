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
        fetcher.getNextEvent { (result) in
            switch result {
            case .Failure(let error):
                // TODO obviously handle the error cases
                print("we got an error", error)
                
            case .Success(let event):
                let proxy = FoursquareProxy.init()
                proxy.getVenueWith(event.foursquareID, completion: { (result) in
                    switch result {
                    case .Failure:
                        // TODO obviously handle the error cases
                        print("we got an error", result)
                        
                    case .Success(let venue):
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

