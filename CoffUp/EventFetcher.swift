//
//  EventFetcher.swift
//  CoffUp
//
//  Created by Roderic on 6/22/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation
import CloudKit

class EventFetcher {
    
    private func publicDatabase() -> CKDatabase {
        let container = CKContainer(identifier: "iCloud.io.thumbworks.CoffUp")
        let publicDatabase = container.publicCloudDatabase
        return publicDatabase
    }
    
    func addEvent(foursquareID : String, date : NSDate, completion: (RequestResult<Void>) -> Void) {
        let dateAsString = NSDate().longFormat()
        
        // Populate a CKRecord
        let eventRecordID = CKRecordID(recordName:dateAsString)
        let eventRecord = CKRecord(recordType:"Event", recordID: eventRecordID)
        eventRecord["foursquareID"] = foursquareID
        eventRecord["date"] = date
        
        // Save the CKRecord to the cloud
        publicDatabase().saveRecord(eventRecord, completionHandler: { (record, error) in
            if let error = error {
                print("error while attempting to write this generic record is ", error)
                completion(RequestResult.Failure(error))
                return
            }
            completion(RequestResult.Success())
            print("Generic record was successfully written")
        })
    }
    
    func getNextEvent(completion: (RequestResult<Event>) -> Void) {
        let eventPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Event", predicate: eventPredicate)
        publicDatabase().performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if let error = error {
                // Per this: http://stackoverflow.com/questions/26551816/cloudkit-error-when-querying-public-database-from-simulator
                // It could also be that I'm not logged into the simulator
                print("Error while querying for all events", error)
                completion(RequestResult.Failure(error))
            } else {
                if let theseRecords = records {
                    print("ok we got something from the cloud. Let's send it", theseRecords.count)
                    var events = Array<Event>()
                    for record in theseRecords {
                        if let fID = record["foursquareID"] as? String, date = record["date"] as? NSDate {
                            events.append(Event(newFoursquareID: fID, newDate: date))
                        }
                    }
                    // hard coded send the first item
                    // TODO we can be a little smarter about sending the next event in the future
                    if let event = events.first {
                        completion(RequestResult.Success(event))
                    }
                }
            }
        }    }
}