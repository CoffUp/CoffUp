//
//  ViewController.swift
//  CoffUpdate
//
//  Created by Roderic on 6/27/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import UIKit

class CoffUpdateViewController: UIViewController {

    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var proxy: FoursquareProxy?
    var venues = [Venue]()
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        print(textField?.text)
        textField?.resignFirstResponder()
        guard let text = textField?.text else {
            return
        }
        if proxy == nil {
            proxy = FoursquareProxy()
        }
        
        // Just trying out doing a search.
        proxy?.searchVenueWithString(text, completion: { (results) in
            switch results {
            case .Failure:
                print("error when searching", results)
            case .Success(let venues):
                self.venues = venues
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func showAlertWith(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(okButton)
        self.showViewController(alert, sender: self)
    }
    
    @IBAction func submitMeetup(sender: AnyObject) {
        guard let selectedCell = tableView.indexPathForSelectedRow else {
            showAlertWith("Select a Venue")
            print("Must make a venue selection")
            return
        }
        guard let venue = venues[selectedCell.row] as Venue? else {
            print("Must have a venue for the selected cell")
            return
        }
        
        print("Attempting to add venue", venue.foursquareID, "date", datePicker.date)
        EventFetcher().addEvent(venue.foursquareID, date: datePicker.date) { (result) in
            dispatch_async(dispatch_get_main_queue(), {
                switch result {
                case .Failure(let error):
                    self.showAlertWith(error.localizedDescription)
                case .Success():
                    self.showAlertWith("Successfully added an event")
                }
            })
        }
    }
}

extension CoffUpdateViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("searchResultsCell") else {
            return UITableViewCell()
        }
        
        if let label = cell.textLabel, subLabel = cell.detailTextLabel, venue = venues[indexPath.row] as Venue? {
            label.text = venue.name
            subLabel.text = venue.crossStreet
        }
        return cell
    }
}