//
//  URL+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 01/11/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension URL {
    
    init(static staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }
    
    func value(forQueryItem key: String) -> String? {
        
        guard let components = NSURLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        return components.queryItems?.first { $0.name == key }?.value
    }
    
    var isWebURL: Bool {
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let scheme = components.scheme {
            return scheme == "https" || scheme == "http"
        }
        return false
    }
}
