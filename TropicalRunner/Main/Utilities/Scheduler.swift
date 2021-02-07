//
//  Schedule.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 04/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

protocol SchedulerProtocol {
    init(interval: TimeInterval, owner: AnyObject, repeats: Bool, callback: @escaping () -> Void)
    func start()
    func stop()
}

final class Scheduler: SchedulerProtocol {
    
    private let interval: TimeInterval
    private weak var owner: AnyObject?
    private let repeats: Bool
    private let callback: () -> Void
    private var timer: Timer?
    
    required init(interval: TimeInterval, owner: AnyObject, repeats: Bool, callback: @escaping () -> Void) {
        self.interval = interval
        self.owner = owner
        self.repeats = repeats
        self.callback = callback
    }
    
    func start() {
        
        if (timer?.isValid).isTrue {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(fire),
                                     userInfo: nil,
                                     repeats: repeats)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func fire() {
        
        if owner == nil {
            timer?.invalidate()
            timer = nil
            return
        }
        
        callback()
    }
}
