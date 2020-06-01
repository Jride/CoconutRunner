//
//  Bundle+LoadFromNib.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 18/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

// swiftlint:disable force_cast

import Foundation
import UIKit

public extension Bundle {
    
    func viewFromNib<T: UIView>(withType type: T.Type,
                                nibName: String? = nil,
                                owner: Any? = nil) -> T {
        
        guard let fileName = nibName ?? "\(type)".components(separatedBy: ".").last else {
            fatalError("Unable to obtain file name of xib")
        }
        
        let nibViews = Bundle.main.loadNibNamed(fileName, owner: owner, options: nil)
        
        guard let view = nibViews?.first(where: { $0 is T }) else {
            fatalError("Xib does not contain correct view type")
        }
      
        return view as! T
    }
    
    func data(fromFileNamed resource: String) -> Data? {
        
        guard
            let url = self.url(forResource: resource, withExtension: ""),
            let data = try? Data(contentsOf: url)
            else {
                return nil
        }
        
        return data
        
    }
    
}
