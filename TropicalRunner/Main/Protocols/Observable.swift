//
//  Observable.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

enum DispatchBehaviour {
    case immediately
    case onQueue(DispatchQueue)
    
    func dispatch(closure: @escaping () -> Void) {
        switch self {
        case .immediately:
            closure()
        case .onQueue(let queue):
            queue.async {
                closure()
            }
        }
    }
}

struct ObserverStore<ObserverType> {
    
    class StoredObserver {
        weak var observer: AnyObject?
        let dispatchBehaviour: DispatchBehaviour
        
        init(observer: AnyObject, dispatchBehaviour: DispatchBehaviour) {
            self.observer = observer
            self.dispatchBehaviour = dispatchBehaviour
        }
    }
    
    var storedObservers = [StoredObserver]()
    
    mutating func add(observer: ObserverType, dispatchBehaviour: DispatchBehaviour) {
        
        removeDeallocatedObservers()
        
        if storedObservers.contains(where: { ($0.observer as AnyObject) === (observer as AnyObject) }) {
            return
        }
        
        let storedObserver = StoredObserver(observer: observer as AnyObject, dispatchBehaviour: dispatchBehaviour)
        storedObservers.append(storedObserver)
    }
    
    mutating func remove(observer: ObserverType) {
        removeDeallocatedObservers()
        storedObservers.removeAll { ($0.observer as AnyObject) === (observer as AnyObject) }
    }
    
    func forEach(_ handler: @escaping (ObserverType) -> Void) {
        
        for storedObserver in storedObservers {
            
            guard let observer = storedObserver.observer as? ObserverType else { continue }
            
            switch storedObserver.dispatchBehaviour {
            case .immediately:
                handler(observer)
            case .onQueue(let dispathQueue):
                dispathQueue.async {
                    handler(observer)
                }
            }
        }
    }
    
    mutating private func removeDeallocatedObservers() {
        storedObservers.removeAll { $0.observer == nil }
    }
}

protocol Observable: class {
    associatedtype ObserverType: Any
    var observerStore: ObserverStore<ObserverType> {get set}
}

extension Observable {
    
    func add(observer: ObserverType, dispatchBehaviour: DispatchBehaviour) {
       observerStore.add(observer: observer, dispatchBehaviour: dispatchBehaviour)
    }
    
    func remove(observer: ObserverType) {
        observerStore.remove(observer: observer)
    }
}
