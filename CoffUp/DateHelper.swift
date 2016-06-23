//
//  DateHelper.swift
//  CoffUp
//
//  Created by Roderic on 6/23/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation

extension NSDate {
    func shortFormat() -> String {
        return NSDateFormatter.shortFormatter.stringFromDate(self)
    }
    
    func longFormat() -> String {
        return NSDateFormatter.longFormatter.stringFromDate(self)
    }
}

extension NSDateFormatter {
    private static let shortFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    private static let longFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .LongStyle
        return formatter
    }()
}