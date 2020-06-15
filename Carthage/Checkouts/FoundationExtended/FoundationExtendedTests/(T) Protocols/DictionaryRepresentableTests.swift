//
//  DictionaryRepresentableTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 17/12/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

private struct Person {
    let firstName: String
    let lastName: String
}

extension Person: DictionaryDecodable {
    
    init?(dictionary: [String : Any]) {
        
        guard
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String else {
            return nil
        }
        
        self.init(firstName: firstName, lastName: lastName)
    }
}

class DictionaryRepresentableTests: XCTestCase {
    
    func test_DictionaryRepresentableWithCodable() {
        
        struct Foo: Codable, DictionaryRepresentable {
            let string: String
            let int: Int
        }
        
        let foo = Foo(string: "abc", int: 5)
        
        XCTAssertEqual(foo.toDictionaryAndBack?.string, "abc")
        XCTAssertEqual(foo.toDictionaryAndBack?.int, 5)
    }
    
    // MARK: - Dictionary Extensions
    
    private var personDictionary: [String: Any] = [
       "person": [
            "firstName": "Scooby",
            "lastName": "Doo"
        ]
    ]
    
    private var personsDictionary: [String: Any] = [
       "persons": [
            [
                "firstName": "Scooby",
                "lastName": "Doo"
            ],
            [
                "firstName": "Stancho",
                "lastName": "Stanchev"
            ],
            [
                "firstName": "Xcode",
                "lastName": "Swift"
            ],
            [
                "firstName": nil,
                "lastName": "Swift"
            ],
            [ "some" : nil ],
            [ "more" : "of nothing"]
        ]
    ]
    
    func test_DictionaryDecodeSubDictionary_Optional() {
        
        let person = personDictionary.decode(Person.self, key: "person")
        
        XCTAssertEqual(person?.firstName, "Scooby")
        XCTAssertEqual(person?.lastName, "Doo")
    }
    
    func test_DictionaryDecodeSubDictionary_Throwing() throws {
        do {
            let person = try personDictionary.decode(throwing: Person.self, key: "person")
            XCTAssertEqual(person.firstName, "Scooby")
            XCTAssertEqual(person.lastName, "Doo")
        } catch {
            XCTFail("Decode fail: \(error)")
        }
    }
    
    func test_DictionaryDecodeSubDictionary_Throwing_Fail() throws {
        
        personDictionary["person"] = nil
        
        XCTAssertThrowsError(try personDictionary.decode(throwing: Person.self, key: "person"))
    }
    
    func test_DictionaryDecodable_Array_Success() {
        
        let persons = personsDictionary.array(of: Person.self, key: "persons")
        
        XCTAssertFalse(persons.isEmpty)
        XCTAssertEqual(persons.count, 3)
        XCTAssertEqual(persons[maybe: 0]?.firstName, "Scooby")
        XCTAssertEqual(persons[maybe: 1]?.firstName, "Stancho")
        XCTAssertEqual(persons[maybe: 2]?.firstName, "Xcode")
        XCTAssertEqual(persons[maybe: 0]?.lastName, "Doo")
        XCTAssertEqual(persons[maybe: 1]?.lastName, "Stanchev")
        XCTAssertEqual(persons[maybe: 2]?.lastName, "Swift")
    }
    
    func test_DictionaryDecodable_Array_Empty() {
        
        personsDictionary["persons"] = []
        
        let persons = personsDictionary.array(of: Person.self, key: "persons")
        
        XCTAssertTrue(persons.isEmpty)
    }
    
    func test_DictionaryDecodable_Array_Nil() {
        
        personsDictionary["persons"] = nil
        
        let persons = personsDictionary.array(of: Person.self, key: "persons")
        
        XCTAssertTrue(persons.isEmpty)
    }
}
