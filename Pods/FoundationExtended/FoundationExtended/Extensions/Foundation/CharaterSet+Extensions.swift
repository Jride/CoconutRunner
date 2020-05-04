//
//  CharaterSet+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 14/08/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension CharacterSet {
    
    /// CharaterSet containing only alphanumberic charaters, without special charaters
    /// (eg. with umlauts)
    static let basicAlphanumeric = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    
    /// CharacterSet containing only the space character
    static let space = CharacterSet(charactersIn: " ")
}
