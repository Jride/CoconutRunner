//
//  DictionaryRepresentable+Testing.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 17/12/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation
import FoundationExtended

extension DictionaryEncodable where Self: DictionaryDecodable {
    
    var toDictionaryAndBack: Self? {
        return Self(dictionary: self.dictionaryRepresentation)
    }
}
