//
//  Array+FirstMatching.swift
//  FoundationExtended
//
//  Created by Andrew Brown on 17/01/2020.
//  Copyright © 2020 ITV. All rights reserved.
//

import Foundation

extension Array {
    public func first(number: Int, matching: (Element) -> Bool) -> [Element] {
        var items = [Element]()
        
        for element in self {
            
            if matching(element) {
                items.append(element)
                guard items.count < number else { break }
            }
        }
        return items
    }
}
