//
//  Fonts.swift
//  TropicalRunner
//
//  Created by Josh Rideout on 07/02/2021.
//  Copyright © 2021 JoshRideout. All rights reserved.
//

import Foundation
import UIKit

final class ITVFonts {
    
    // MARK: - ITVReem
    
    static func itvReem(size: CGFloat) -> UIFont {
        return UIFont(name: "ITVReem", size: size)!
    }
    
    static let fontCoefficient: CGFloat = Env.device.isIphone5LikeDevice ? 3/4 : 1
}
