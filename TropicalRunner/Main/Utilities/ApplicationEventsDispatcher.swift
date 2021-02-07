//
//  ApplicationEventsDispatcher.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import Foundation
import FoundationExtended

protocol ApplicationEventsDispatcherObserver: class {
    func applicationDidBecomeActive(fromBackground: Bool)
    func applicationWillEnterForeground()
    func applicationDidEnterBackground()
    func applicationDidReceiveMemoryWarning()
    func applicationObservedSignificantTimeChange()
    func applicationWillResignActive()
    func applicationWillTerminate()
}

extension ApplicationEventsDispatcherObserver {
    func applicationDidBecomeActive(fromBackground: Bool) {}
    func applicationWillEnterForeground() {}
    func applicationDidEnterBackground() {}
    func applicationDidReceiveMemoryWarning() {}
    func applicationObservedSignificantTimeChange() {}
    func applicationWillResignActive() {}
    func applicationWillTerminate() {}
}

protocol ApplicationEventsDispatcher {
    func add(observer: ApplicationEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: ApplicationEventsDispatcherObserver)
}

final class ApplicationEventsDispatcherImpl: ApplicationEventsDispatcher, Observable {
    
    var observerStore = ObserverStore<ApplicationEventsDispatcherObserver>()
    
    private let notificationsCenter: NotificationCenter
    private var enteredbackgroundDuringInactiveState = false
    
    init(notificationsCenter: NotificationCenter) {
        
        self.notificationsCenter = notificationsCenter
                
        func observe(_ name: Notification.Name, at selector: Selector) {
            self.notificationsCenter.addObserver(self, selector: selector, name: name, object: nil)
        }
        
        observe(UIApplication.didBecomeActiveNotification, at: #selector(applicationDidBecomeActive))
        observe(UIApplication.willEnterForegroundNotification, at: #selector(applicationDidEnterForeground))
        observe(UIApplication.didEnterBackgroundNotification, at: #selector(applicationDidEnterBackground))
        observe(UIApplication.didReceiveMemoryWarningNotification, at: #selector(applicationDidReceiveMemoryWarning))
        observe(UIApplication.significantTimeChangeNotification, at: #selector(applicationSignificantTimeChange))
        observe(UIApplication.willResignActiveNotification, at: #selector(applicationWillResignActive))
        observe(UIApplication.willTerminateNotification, at: #selector(applicationWillTerminate))
    }
    
    convenience init() {
        self.init(notificationsCenter: NotificationCenter.default)
    }
    
    @objc func applicationDidBecomeActive() {
        let wasInBackground = enteredbackgroundDuringInactiveState
        observerStore.forEach { $0.applicationDidBecomeActive(fromBackground: wasInBackground) }
        enteredbackgroundDuringInactiveState = false
    }
    
    @objc func applicationDidEnterForeground() {
        observerStore.forEach { $0.applicationWillEnterForeground() }
    }
    
    @objc func applicationDidEnterBackground() {
        enteredbackgroundDuringInactiveState = true
        observerStore.forEach { $0.applicationDidEnterBackground() }
    }
    
    @objc func applicationDidReceiveMemoryWarning() {
        observerStore.forEach { $0.applicationDidReceiveMemoryWarning() }
    }
    
    @objc func applicationSignificantTimeChange() {
        observerStore.forEach { $0.applicationObservedSignificantTimeChange() }
    }
    
    @objc func applicationWillResignActive() {
        enteredbackgroundDuringInactiveState = false
        observerStore.forEach { $0.applicationWillResignActive() }
    }
    
    @objc func applicationWillTerminate() {
        observerStore.forEach { $0.applicationWillTerminate() }
    }
}
