//
//  Array+IdentityEquatable.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Array where Element: IdentityEquatable {
    
    mutating func appendOrReplace(identityEquatable newElement: Element) {
        
        var replacementIndex: Int?
        
        for (index, element) in enumerated() where element.equatableId == newElement.equatableId {
            replacementIndex = index
            break
        }
        
        if let index = replacementIndex {
            remove(at: index)
            insert(newElement, at: index)
        } else {
            append(newElement)
        }
    }
}
