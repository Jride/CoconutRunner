//
//  SignedNumeric+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension SignedNumeric where Self: Comparable {
    
    var abs: Self {
        return Swift.abs(self)
    }
    
    func absDistance(to other: Self) -> Self {
        return Swift.abs(self - other)
    }
}

