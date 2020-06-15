//
//  BuilderTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 30/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class BuilderTests: XCTestCase {
    
    func test_DogStructBuilder_VendsCorrectValues() {
        
        let newDog = Builder(Dog.self)
            .with(init: \.breed, "Shih Tzu")
            .with(\.age, 5)
            .with(\.name, "Penny")
            .build()
        
        XCTAssertEqual(newDog, Dog(breed: "Shih Tzu", name: "Penny", age: 5))
    }
    
    func test_JobStructBuilder_VendsCorrectValues() {
        
        let newJob = Builder(Job.self)
            .with(\.position, "iOS Developer")
            .with(\.salary, 10000)
            .build()
        
        XCTAssertEqual(newJob, Job(position: "iOS Developer", salary: 10000))
    }
    
    func test_PersonClassBuilder_VendsCorrectValues() {
        
        let newPerson = Builder(Person.self)
            .with(init: \.firstname, "Perry")
            .with(init: \.lastname, "Cox")
            .with(\.age, 45)
            .with(\.dog, Builder(Dog.self)
                .with(init: \.breed, "Labradoodle")
                .with(\.name, "JD")
                .with(\.age, 3)
                .build())
            .with(\.job, Builder(Job.self)
                .with(\.position, "Chief of Medicine")
                .with(\.salary, 900000)
                .build())
            .build()
        
        XCTAssertEqual(newPerson.job, Job(position: "Chief of Medicine", salary: 900000))
        XCTAssertEqual(newPerson.dog, Dog(breed: "Labradoodle", name: "JD", age: 3))
        
        XCTAssertEqual(newPerson.name, "Perry Cox")
        XCTAssertEqual(newPerson.age, 45)
    }
    
}

// MARK: - Test Scope

// Extend Person, Dog and Job to be buildable

extension Person: Buildable {
    
    // Extract out the class's initialiser properties
    struct PersonConfiguration {
        var firstname: String
        var lastname: String
        var age: Int
    }
    
    static func createBuildableInstance(configuration: PersonConfiguration) -> Person {
        return Person(firstname: configuration.firstname,
                      lastname: configuration.lastname,
                      age: configuration.age)
    }
    
    static func createBuildableConfiguration() -> PersonConfiguration {
        return PersonConfiguration(firstname: "John", lastname: "Doe", age: 30)
    }
    
}

extension Job: Buildable {
    
    static func createBuildableInstance(configuration: Void) -> Job {
        return Job(position: "Janitor", salary: 20000)
    }
    
}

extension Dog: Buildable {
    
    // Extract immutable properties out into a configuration object
    struct DogConfiguration {
        var breed: String
    }
    
    static func createBuildableConfiguration() -> DogConfiguration {
        return DogConfiguration(breed: "Mutt")
    }
    
    static func createBuildableInstance(configuration: DogConfiguration) -> Dog {
        return Dog(breed: configuration.breed, name: "Unknown name", age: 0)
    }
}

// MARK: - Production Types

fileprivate final class Person {
    
    let name: String
    var age: Int
    var dog: Dog?
    var job: Job?
    
    init(firstname: String, lastname: String, age: Int) {
        self.name = [firstname, lastname].joined(separator: " ")
        self.age = age
    }
}

fileprivate struct Dog: Equatable {
    let breed: String
    var name: String
    var age: Int
}

fileprivate struct Job: Equatable {
    var position: String
    var salary: Int
}
