//
//  Result+Extension.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 25/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

extension Swift.Result {
    
    public var error: Error? {
        switch  self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
}
