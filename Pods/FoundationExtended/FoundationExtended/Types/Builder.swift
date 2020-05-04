//
//  Builder.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 30/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public protocol Buildable {
    associatedtype BuilderConfiguration
    static func createBuildableInstance(configuration: BuilderConfiguration) -> Self
    static func createBuildableConfiguration() -> BuilderConfiguration
}

public extension Buildable where BuilderConfiguration == Void  {
    static func createBuildableConfiguration() -> BuilderConfiguration {
        return Void()
    }
}

public class Builder<T: Buildable, C> where C == T.BuilderConfiguration {
    
    private var instance: T!
    private var configuration: C = T.createBuildableConfiguration()
    
    private var configTransformations = [() -> Void]()
    private var transformations = [() -> Void]()
    
    public init(_ buildableType: T.Type) {}
    
    @discardableResult
    public func with<U>(init keyPath: WritableKeyPath<C, U>, _ value: U) -> Self {
        configTransformations.append { [unowned self] in
            self.configuration[keyPath: keyPath] = value
        }
        return self
    }
    
    @discardableResult
    public func with<U>(init keyPath: WritableKeyPath<C, U?>, _ value: U?) -> Self {
        configTransformations.append { [unowned self] in
            self.configuration[keyPath: keyPath] = value
        }
        return self
    }
    
    @discardableResult
    public func with<U>(_ keyPath: WritableKeyPath<T, U>, _ value: U) -> Self {
        transformations.append { [unowned self] in
            self.instance[keyPath: keyPath] = value
        }
        return self
    }
    
    @discardableResult
    public func with<U>(_ keyPath: WritableKeyPath<T, U?>, _ value: U?) -> Self {
        transformations.append { [unowned self] in
            self.instance[keyPath: keyPath] = value
        }
        return self
    }
    
    public func build() -> T {
        
        // Apply the transformations to the configuration first
        configTransformations.forEach { $0() }
        
        // Create the instance with the configuration
        instance = T.createBuildableInstance(configuration: configuration)
        
        // Apply the transformations to the instance
        transformations.forEach { $0() }
        
        return instance
    }
}
