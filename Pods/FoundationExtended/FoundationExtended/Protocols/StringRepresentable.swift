//
//  StringRepresentable.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public protocol StringRepresentable {
    
    init?(string: String)
    var stringRepresentation: String { get }
}

public extension StringRepresentable where Self: RawRepresentable, RawValue == String {
    init?(string: String) {
        self.init(rawValue: string)
    }
    
    var stringRepresentation: String {
        return self.rawValue
    }
}
