//
//  NotificationDispatcherTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 30/10/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

fileprivate protocol ProtocolA: class {
    func functionA()
}

fileprivate protocol ProtocolB: class {
    func functionB()
}

fileprivate class ClassA: ProtocolA {
    var numCalls = 0
    func functionA() {
        numCalls += 1
    }
}

fileprivate class ClassB: ProtocolB {
    var numCalls = 0
    func functionB() {
        numCalls += 1
    }
}

class NotificationDispatcherTests: XCTestCase {
    
    let notificationDispatcher = NotificationDispatcher()
    
    // MARK: - Notification Sending
    
    func test_SingleObserver_RecievesNotification() {
        
        let observer = ClassA()
        notificationDispatcher.register(observer: observer, as: ProtocolA.self)
        
        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(observer.numCalls, 1)
        
        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(observer.numCalls, 2)
    }
    
    func test_MultipleObserversForProtocol_AllRecieveNotification() {
        
        let observer1 = ClassA()
        let observer2 = ClassA()
        
        notificationDispatcher.register(observer: observer1, as: ProtocolA.self)
        notificationDispatcher.register(observer: observer2, as: ProtocolA.self)
        
        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(observer1.numCalls, 1)
        XCTAssertEqual(observer2.numCalls, 1)

        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(observer1.numCalls, 2)
        XCTAssertEqual(observer2.numCalls, 2)
    }
    
    func test_MultipleObservedProtocols_AllRecieveNotification() {
        
        let observerA = ClassA()
        let observerB = ClassB()
        
        notificationDispatcher.register(observer: observerA, as: ProtocolA.self)
        notificationDispatcher.register(observer: observerB, as: ProtocolB.self)
        
        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(observerA.numCalls, 1)
        XCTAssertEqual(observerB.numCalls, 0)
        
        notificationDispatcher.notify(ProtocolB.self) { $0.functionB() }
        XCTAssertEqual(observerA.numCalls, 1)
        XCTAssertEqual(observerA.numCalls, 1)
    }
    
    // MARK: - Observer Retain Cycles
    
    func test_ObserversAreNotRetained() {
        
        var strongObserver: ClassA? = ClassA()
        weak var weakObserver: ClassA? = strongObserver
        
        notificationDispatcher.register(observer: strongObserver!, as: ProtocolA.self)
        
        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        XCTAssertEqual(weakObserver?.numCalls, 1)
        
        strongObserver = nil
        XCTAssertNil(weakObserver)
    }
    
    // MARK: - Observing Multiple times
    
    func test_ObserversCannotRegisterMultipleTimesForTheSameProtocol() {
        
        let observer = ClassA()
        
        notificationDispatcher.register(observer: observer, as: ProtocolA.self)
        notificationDispatcher.register(observer: observer, as: ProtocolA.self)

        notificationDispatcher.notify(ProtocolA.self) { $0.functionA() }
        
        XCTAssertEqual(observer.numCalls, 1)
    }
}
