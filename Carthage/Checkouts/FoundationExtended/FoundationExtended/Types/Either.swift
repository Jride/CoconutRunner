//
//  Either.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 13/08/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
    
    // MARK: - Replace
    
    public mutating func replaceLeft(_ value: Left) {
        
        switch self {
        case .left:
            self = .left(value)
        case .right:
            break
        }
    }
    
    public mutating func replaceRight(_ value: Right) {
        
        switch self {
        case .left:
            break
        case .right:
            self = .right(value)
        }
    }
    
    // MARK: - Mutate
    
    public mutating func mutateLeft(_ mutate: (inout Left) -> Void) {
        
        switch self {
        case .left(var l):
            mutate(&l)
            self = .left(l)
        case .right:
            break
        }
    }
    
    public mutating func mutateRight(_ mutate: (inout Right) -> Void) {
        
        switch self {
        case .left:
            break
        case .right(var r):
            mutate(&r)
            self = .right(r)
        }
    }
    
    // MARK: - Map    
        
    public func map<T>(_ l: (Left) -> T, _ r: (Right) -> T) -> T {
        switch self {
        case .left(let left):
            return l(left)
        case .right(let right):
            return r(right)
        }
    }
}

extension Either: Equatable where Left: Equatable, Right: Equatable {
    public static func == (lhs: Either<Left, Right>, rhs: Either<Left, Right>) -> Bool {
        switch (lhs, rhs) {
        case let (.left(l1), .left(l2)):
            return l1 == l2
        case let (.right(r1), .right(r2)):
            return r1 == r2
        default:
            return false
        }
    }
}
