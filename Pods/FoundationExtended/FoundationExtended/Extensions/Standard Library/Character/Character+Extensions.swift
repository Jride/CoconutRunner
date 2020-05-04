//
//  Character+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 07/09/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Character {
    
    var isDigit: Bool {
        switch self {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            return true
        default:
            return false
        }
    }
}
