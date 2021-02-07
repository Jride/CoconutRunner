//
//  CGSize+Extensions.swift
//  TropicalRunner
//
//  Created by Josh Rideout on 07/02/2021.
//  Copyright © 2021 JoshRideout. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    var isLandscape: Bool {
        return width > height
    }
    
    var isPortrait: Bool {
        return height > width
    }
}
