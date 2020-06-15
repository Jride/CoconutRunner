//
//  String+Quoted.swift
//  FoundationExtended
//
//  Created by Tom O'Rourke on 25/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension String {
    
    var quoted: String {
        return "\"\(self)\""
    }
    
}
