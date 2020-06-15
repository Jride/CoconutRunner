//
//  URLSession+Synchronous.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 09/10/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension URLSession {
    
    /// Runs a data task synchronously. Don't call from the main thread, as will block it.
    ///
    /// - Parameter url: The url to call
    /// - Returns: Tuple with data, response and error
    func synchronousDataTask(with url: URL) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
    
    /// Runs a data task synchronously. Don't call from the main thread, as will block it.
    ///
    /// - Parameter request: The url to call
    /// - Returns: Tuple with data, response and error
    func synchronousDataTask(with request: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
