//
//  CGRect+Extensions.swift
//  TropicalRunner
//
//  Created by Josh Rideout on 07/02/2021.
//  Copyright © 2021 JoshRideout. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    var isLandscape: Bool {
        return size.isLandscape
    }
    
    var isPortrait: Bool {
        return size.isPortrait
    }
}
