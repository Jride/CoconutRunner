//
//  Color.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 30/05/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public struct Color: Equatable {
    public var r: Double
    public var g: Double
    public var b: Double
    public var a: Double
    
    public init(r: Double, g: Double, b: Double, a: Double = 1) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    public init(r255 r: Double, g: Double, b: Double, a: Double = 1) {
        self.r = r/255
        self.g = g/255
        self.b = b/255
        self.a = a
    }
}

// MARK: - Colors

public extension Color {
    static let black = Color(r: 0, g: 0, b: 0)
    static let blue = Color(r: 0, g: 0, b: 1)
    static let clear = Color(r: 0, g: 0, b: 0, a: 0)
    static let green = Color(r: 0, g: 1, b: 0)
    static let red = Color(r: 1, g: 0, b: 0)
    static let white = Color(r: 1, g: 1, b: 1)
}

// MARK: - Alter Color

public extension Color {
    
    func darker(toPct pct: Double) -> Color {
        return Color(r: self.r * pct,
                     g: self.g * pct,
                     b: self.b * pct,
                     a: self.a)
    }
}
