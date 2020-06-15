//
//  Array+Filtering.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Array {
    
    public func removing(shouldRemove: (Element) -> Bool) -> [Element] {
        return self.filter { !shouldRemove($0) }
    }
    
    public mutating func filterInPlace(isIncluded: (Element) -> Bool) {
        self = self.filter(isIncluded)
    }
}
