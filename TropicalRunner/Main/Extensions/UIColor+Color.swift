//
//  UIColor+Color.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 27/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import Foundation
import FoundationExtended

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }

    convenience init(color: Color) {
        self.init(red: CGFloat(color.r),
                  green: CGFloat(color.g),
                  blue: CGFloat(color.b),
                  alpha: CGFloat(color.a))
    }
}
