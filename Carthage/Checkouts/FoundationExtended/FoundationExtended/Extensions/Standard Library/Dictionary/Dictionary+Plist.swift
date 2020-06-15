//
//  Dictionary+Plist.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    public init?(plistName: String) {
        
        if let plistURL = Bundle.main.url(forResource: plistName, withExtension: "plist"),
            let nsDictionary = NSDictionary(contentsOf: plistURL),
            let swiftDictionary = nsDictionary as? [String: Any] {
            self = swiftDictionary
        } else {
            return nil
        }
    }
}
