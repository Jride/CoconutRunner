//
//  Array+SortBySteps.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Sort by steps

public enum SortStepDirection {
    case ascending
    case descending
}

extension Array {
    
    public class SortStep<Input> {
        
        public enum Result {
            case ascending
            case descending
            case equal
        }
        
        private let sortClosure: (Input, Input) -> Result
        
        public init(sortClosure: @escaping (Input, Input) -> Result) {
            self.sortClosure = sortClosure
        }
        
        public convenience init<Output: Comparable>(direction: SortStepDirection, transform: @escaping (Input) -> Output) {
            
            switch direction {
            case .ascending:
                self.init(ascending: transform)
            case .descending:
                self.init(descending: transform)
            }
        }
        
        public convenience init<Output: Comparable>(ascending transform: @escaping (Input) -> Output) {
            self.init { (lhs, rhs) -> Result in
                let lhsComparable = transform(lhs)
                let rhsComparable = transform(rhs)
                
                if lhsComparable == rhsComparable {
                    return .equal
                } else {
                    return rhsComparable > lhsComparable ? .ascending : .descending
                }
            }
        }
        
        public convenience init<Output: Comparable>(descending transform: @escaping (Input) -> Output) {
            self.init { (lhs, rhs) -> Result in
                let lhsComparable = transform(lhs)
                let rhsComparable = transform(rhs)
                
                if lhsComparable == rhsComparable {
                    return .equal
                } else {
                    return rhsComparable < lhsComparable ? .ascending : .descending
                }
            }
        }
        
        public convenience init(trueFirst transform: @escaping (Input) -> Bool) {
            self.init { (lhs, rhs) -> Result in
                
                switch (transform(lhs), transform(rhs)) {
                case (true, false): return .ascending
                case (false, true): return .descending
                default: return .equal
                }
            }
        }
        
        public convenience init(falseFirst transform: @escaping (Input) -> Bool) {
            self.init { (lhs, rhs) -> Result in
                
                switch (transform(lhs), transform(rhs)) {
                case (false, true): return .ascending
                case (true, false): return .descending
                default: return .equal
                }
            }
        }
        
        fileprivate func sort(lhs: Input, rhs: Input) -> Result {
            return sortClosure(lhs, rhs)
        }
    }
    
    // MARK: - Sort
    
    public mutating func sortBySteps(_ steps: [SortStep<Element>]) {
        
        if steps.isEmpty {
            return
        }
        
        sort { (lhs, rhs) -> Bool in
            
            var index = 0
            while let step = steps[maybe: index] {
                
                let result = step.sort(lhs: lhs, rhs: rhs)
                switch result {
                case .ascending: return true
                case .descending: return false
                case .equal: break
                }
                
                index += 1
            }
            
            return true
        }
    }
    
    public mutating func sortBySteps(_ steps: SortStep<Element>...) {
        sortBySteps(steps)
    }
    
    // MARK: - Sorted
    
    public func sortedBySteps(_ steps: SortStep<Element>...) -> [Element] {
        return sortedBySteps(steps)
    }
    
    public func sortedBySteps(_ steps: [SortStep<Element>]) -> [Element] {
        var sortedArray = self
        sortedArray.sortBySteps(steps)
        return sortedArray
    }
    
    // MARK: - First / Last Sorted
    
    public func first(sortedBySteps steps: [SortStep<Element>]) -> Element? {
        
        var firstValue: Element?
        
        for value in self {
            guard let fv = firstValue else {
                firstValue = value
                continue
            }
            
            let direction = self.sortResult(lhs: fv, rhs: value, steps: steps)
            switch direction {
            case .descending:
                firstValue = value
            default:
                break
            }
        }
        
        return firstValue
    }
    
    public func last(sortedBySteps steps: [SortStep<Element>]) -> Element? {
        
        var lastValue: Element?
        
        // Iterate reversed, so that we can keep the first value we come accross (last in
        // the array). This might also save a few writes to lastValue in the event that the
        // array has already been sorted.
        for value in self.reversed() {
            guard let lv = lastValue else {
                lastValue = value
                continue
            }
            
            let direction = self.sortResult(lhs: lv, rhs: value, steps: steps)
            switch direction {
            case .ascending:
                lastValue = value
            default:
                break
            }
        }
        
        return lastValue
    }
    
    // MARK: - Insert
    
    /// - Returns: The step the that the item was inserted at
    @discardableResult public mutating func insert(_ element: Element, sortSteps: [SortStep<Element>]) -> Int {
        
        if sortSteps.isEmpty {
            append(element)
            return 0
        }
        
        for (index, existingElement) in enumerated() {
            switch sortResult(lhs: existingElement, rhs: element, steps: sortSteps) {
            case .ascending:
                continue
            case .descending:
                self.insert(element, at: index)
                return index
            case .equal:
                break
            }
        }
        
        append(element)
        return lastIndex!
    }
    
    // MARK: - Private
    
    private func sortResult(lhs: Element, rhs: Element, steps: [SortStep<Element>]) -> SortStep<Element>.Result {
        
        var index = 0
        while let step = steps[maybe: index] {
            
            let result = step.sort(lhs: lhs, rhs: rhs)
            switch result {
            case .ascending: return .ascending
            case .descending: return .descending
            case .equal: break
            }
            
            index += 1
        }
        
        return .equal
    }
}

