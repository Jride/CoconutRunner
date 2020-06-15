//
//  NotificationDispatcher.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 30/10/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

fileprivate class ObserverStore<T> {
    private(set) var observers = WeakObjectSet<T>()
    
    func add(observer: T) {
        observers.insert(object: observer)
    }
}

public final class NotificationDispatcher {
    
    public static let shared = NotificationDispatcher()
    
    var stores = [String: Any]()
    
    public init() {}
    
    public func register<T>(observer: AnyObject, as observerType: T.Type) {
        
        guard let observer = observer as? T else {
            return
        }

        let key = String(describing: observerType)
        
        let store: ObserverStore<T>
        
        if let existingStore = stores[key] as? ObserverStore<T> {
            store = existingStore
        } else {
            store = ObserverStore<T>()
            stores[key] = store
        }
        
        store.add(observer: observer)
    }
    
    public func notify<T>(_ observerType: T.Type, handler: (T) -> Void) {
        
        let key = String(describing: observerType)
        
        guard let store = stores[key] as? ObserverStore<T> else {
            return
        }

        store.observers.forEach(handler)
    }
}
