//
//  RequestResult.swift
//  CoffUp
//
//  Created by Roderic on 6/28/16.
//  Copyright © 2016 Thumbworks. All rights reserved.
//

import Foundation

enum RequestResult<T> {
    case Success(T)
    case Failure(NSError)
    
    static func success(result: T) -> RequestResult {
        return Success(result)
    }
    
    static func failure(value: NSError) -> RequestResult {
        return Failure(value)
    }
}