//
//  Sequence+Zip.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 16/10/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

extension Sequence {
    
    public func zip<T>(_ transform: @escaping (Element) -> T) -> Zip2Sequence<Self, MappingSequence<Self, T>> {
        let mapped = MappingSequence(sequence: self, transform: transform)
        return Swift.zip(self, mapped)
    }
    
    
    public func compactZip<T>(with transform: @escaping (Element) -> T?) -> CompactZipRightSequence<Self, T> {
        return CompactZipRightSequence(sequence: self, transform: transform)
    }
}

public struct MappingSequence<InnerSequence, T>: Sequence, IteratorProtocol where InnerSequence: Sequence {
    
    private let sequence: InnerSequence
    private var sequenceIterator: InnerSequence.Iterator
    private let transform: (InnerSequence.Element) -> T
    
    fileprivate init(sequence: InnerSequence, transform: @escaping (InnerSequence.Element) -> T) {
           self.sequence = sequence
           self.sequenceIterator = sequence.makeIterator()
           self.transform = transform
       }
    
    public mutating func next() -> T? {
        
        if let value = sequenceIterator.next() {
            return transform(value)
        } else {
            return nil
        }
    }
}

public struct CompactZipRightSequence<InnerSequence, T>: Sequence, IteratorProtocol where InnerSequence: Sequence {

    private let sequence: InnerSequence
    private var sequenceIterator: InnerSequence.Iterator
    private let transform: (InnerSequence.Element) -> T?
    
    fileprivate init(sequence: InnerSequence, transform: @escaping (InnerSequence.Element) -> T?) {
        self.sequence = sequence
        self.sequenceIterator = sequence.makeIterator()
        self.transform = transform
    }
    
    public mutating func next() -> (InnerSequence.Element, T)? {
        
        while let value = sequenceIterator.next() {
            if let transformed = transform(value) {
                return (value, transformed)
            }
        }
        
        return nil
    }
}
