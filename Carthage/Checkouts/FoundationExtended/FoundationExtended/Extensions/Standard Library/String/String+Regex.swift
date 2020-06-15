//
//  String+Regex.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension String {
    
    public func matches(regex: String) -> Bool {
        
        if self.range(of: regex,
                      options: [.regularExpression],
                      range: startIndex..<endIndex,
                      locale: nil) != nil {
            return true
        } else {
            return false
        }
    }
}
