//
//  String+CharacterSet.swift
//  FoundationExtended
//
//  Created by Tom O'Rourke on 25/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension String {
    
    func replacing(charactersInSet characterSet: CharacterSet, with character: Character) -> String {
        
        var newString = ""
        
        for unicodeScaler in self.unicodeScalars {
            if characterSet.contains(unicodeScaler) {
                newString.append(character)
            } else {
                newString.unicodeScalars.append(unicodeScaler)
            }
        }
        
        return newString
    }
    
}
