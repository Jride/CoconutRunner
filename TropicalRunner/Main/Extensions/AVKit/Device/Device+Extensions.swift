//
//  Device+Extensions.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import AVFoundation
import UIKit
import Foundation

extension UIDevice {
    
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
}
