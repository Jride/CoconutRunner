//
//  Device.swift
//  TropicalRunner
//
//  Created by Josh Rideout on 07/02/2021.
//  Copyright © 2021 JoshRideout. All rights reserved.
//

import Foundation
import UIKit
import FoundationExtended

protocol DeviceProtocol {
    
    var osVersion: String { get }
    var model: String { get }
    var identifierForVendor: UUID? { get }
    var screenSize: Vector2<Double> { get }
    var absoluteTime: Double { get }
    var isSecondScreenConnected: Bool { get }
    var isPad: Bool { get }
    var isPhone: Bool { get }
    var isLandscape: Bool { get }
    var isIphone5LikeDevice: Bool { get }
}

final class Device: DeviceProtocol {
    var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var model: String {
        return UIDevice.current.model
    }
    
    var identifierForVendor: UUID? {
        return UIDevice.current.identifierForVendor
    }
    
    var screenSize: Vector2<Double> {
        let cgSize = UIScreen.main.bounds.size
        return Vector2(Double(cgSize.width), Double(cgSize.height))
    }
    
    var absoluteTime: Double {
        return CACurrentMediaTime()
    }
    
    var isPad: Bool { UIDevice.current.isPad }
    var isPhone: Bool { UIDevice.current.isPhone }
    var isLandscape: Bool { UIScreen.main.bounds.isLandscape }
    
    var isIphone5LikeDevice: Bool {
        if isPad { return false }
        return isLandscape ?
            screenSize.width <= 568 :
            screenSize.height <= 568
        
    }
    
    var isSecondScreenConnected: Bool {
        
        guard
            let secondScreen = UIScreen.screens[maybe: 1],
            secondScreen.preferredMode != nil else {
            return false
        }
        
        return true
    }
}
