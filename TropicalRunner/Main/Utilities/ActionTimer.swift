//
//  ActionTimer.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 04/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

final class ActionTimer {
    
    private var lastActionPerformedDate: Date?
    private let timeThreshold: Time
    private var scheduler: Scheduler?
    private let callback: () -> Void
    
    convenience init(timeThreshold: Time, callback: @escaping () -> Void) {
        self.init(timeThreshold: timeThreshold,
                  dispatchBehaviour: .onQueue(.main),
                  callback: callback)
    }
    
    init(timeThreshold: Time,
         dispatchBehaviour: DispatchBehaviour,
         callback: @escaping () -> Void) {
        
        self.timeThreshold = timeThreshold
        self.callback = callback
        
        scheduler = Scheduler(interval: 1.0, owner: self, repeats: true) { [weak self] in
            self?.performActionIfNeeded()
        }
    }
    
    private func performActionIfNeeded() {
        
        guard
            let lastActionPerformedDate = self.lastActionPerformedDate
        else {
            performAction()
            return
        }
        
        let elapsedTime = Env.date().timeIntervalSince(lastActionPerformedDate)
        if elapsedTime > timeThreshold.seconds {
            performAction()
        }
    }
    
    private func performAction() {
        callback()
        lastActionPerformedDate = Env.date()
    }
    
    func delay() {
        lastActionPerformedDate = Env.date()
    }
    
    func start() {
        scheduler?.start()
    }
    
    func stop() {
        scheduler?.stop()
    }
    
}
