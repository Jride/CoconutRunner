//
//  String+URL.swift
//  FoundationExtended
//
//  Created by Tom O'Rourke on 09/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension String {
    
    var URL: Foundation.URL? {
        return Foundation.URL(string: self)
    }
}
