//
//  Optional+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Optional {
    
    public func require(_ errorMessage: String) -> Wrapped {
        
        switch self {
        case .none:
            fatalError(errorMessage)
        case .some(let obj):
            return obj
        }
    }
}

extension Optional {
    
    public enum UnwrapError: Error {
        case OptionalWasNil
    }
    
    public func unwrapThrowing() throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError.OptionalWasNil
        }
    }
}

extension Optional where Wrapped == Bool {
    
    // Can be used to test optional bools for 'falseness'
    // For chained optionals, wrap in parentheses to 'flatten' the type
    // eg. if (optionalType?.boolValue).isNilOrFalse { // do something }
    
    public var isNilOrFalse: Bool {
        
        switch self {
        case .none:
            return true
        case .some(let value):
            return !value
        }
    }
    
    // Can be used to test optional bools for 'trueness'
    // Will be false if the optional is nil
    // For chained optionals, wrap in parentheses to 'flatten' the type
    // eg. if (optionalType?.boolValue).isTrue { // do something }
    
    public var isTrue: Bool {
        
        switch self {
        case .none:
            return false
        case .some(let value):
            return value
        }
    }
}

extension Optional {
    
    public func pipe(maybe f: (Wrapped) -> Void) {
        switch self {
        case .none:
            return
        case .some(let v):
            f(v)
        }
    }
    
}
