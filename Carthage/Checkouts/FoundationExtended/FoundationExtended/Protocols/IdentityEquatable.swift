//
//  IdentityEquatable.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public protocol IdentityEquatable {
    associatedtype ID: Equatable
    var equatableId: ID { get }
}
