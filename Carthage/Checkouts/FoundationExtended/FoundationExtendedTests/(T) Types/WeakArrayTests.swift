//
//  WeakArrayTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class WeakArrayTests: XCTestCase {
    
    // MARK: - Test Init
    
    func testWeakArrayInitialisesWithCorrectObjectsUsingVariadicInit() throws {
        
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        let obj3 = AClass(value: "C")
        
        let weakArray = WeakArray(objects: obj1, obj2, obj3)
        
        XCTAssertEqual(weakArray.count, 3)
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "B")
        XCTAssertEqual(try weakArray.at(throwing: 2).value, "C")
    }
    
    func testWeakArrayInitialisesWithCorrectObjectsUsingArrayInit() throws {
        
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        let obj3 = AClass(value: "C")
        
        let weakArray = WeakArray(objects: [obj1, obj2, obj3])
        
        XCTAssertEqual(weakArray.count, 3)
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "B")
        XCTAssertEqual(try weakArray.at(throwing: 2).value, "C")
    }
    
    // MARK: - Retaining
    
    func testDoesntRetainObjects() throws {
        
        let obj1 = AClass(value: "A")
        var obj2 = Optional.some(AClass(value: "B"))
        let obj3 = AClass(value: "C")
        
        // Array should have 3 objects
        let weakArray = WeakArray(objects: obj1, obj2!, obj3)
        XCTAssertEqual(weakArray.count, 3)
        
        // Release obj2, array should now have 2 objects
        obj2 = nil
        XCTAssertEqual(weakArray.count, 2)
        
        // Check that the indexes have shifted
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "C")
    }
    
    // MARK: - Add Items
    
    func testAddingItemAddsItem() throws {
        
        // Create array with 2 objects
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        var weakArray = WeakArray(objects: obj1, obj2)
        XCTAssertEqual(weakArray.count, 2)
        
        // Append a third object
        let obj3 = AClass(value: "C")
        weakArray.append(obj3)
        
        // Check that the array contains three objects
        XCTAssertEqual(weakArray.count, 3)
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "B")
        XCTAssertEqual(try weakArray.at(throwing: 2).value, "C")
    }
    
    // MARK: - Test Remove Items
    
    func testRemovingItemByClosureRemovesItem() throws {
        
        // Create array with 3 objects
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        let obj3 = AClass(value: "C")
        var weakArray = WeakArray(objects: obj1, obj2, obj3)
        XCTAssertEqual(weakArray.count, 3)
        
        // Remove the middle item
        weakArray.removeAll { $0 === obj2 }
        
        // Check has correct objects
        XCTAssertEqual(weakArray.count, 2)
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "C")
    }
    
    func testRemovingItemByObjectReferenceRemovesItem() throws {
        
        // Create array with 3 objects
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        let obj3 = AClass(value: "C")
        var weakArray = WeakArray(objects: obj1, obj2, obj3)
        XCTAssertEqual(weakArray.count, 3)
        
        // Remove the middle item
        weakArray.remove(object: obj2)
        
        // Check has correct objects
        XCTAssertEqual(weakArray.count, 2)
        XCTAssertEqual(try weakArray.at(throwing: 0).value, "A")
        XCTAssertEqual(try weakArray.at(throwing: 1).value, "C")
    }
    
    func testRemovingAllObjects() {
        
        // Create array with 3 objects
        let obj1 = AClass(value: "A")
        let obj2 = AClass(value: "B")
        let obj3 = AClass(value: "C")
        var weakArray = WeakArray(objects: obj1, obj2, obj3)
        XCTAssertEqual(weakArray.count, 3)
        
        // Remove all
        weakArray.removeAll()
        
        // Check has no objects
        XCTAssertEqual(weakArray.count, 0)
    }

// MARK: - For Each

    func testForEachDoesntIncludeNilValues() {
        
        // Make an array with 3 values
        let obj1 = AClass(value: "A")
        var obj2 = Optional.some(AClass(value: "B"))
        let obj3 = AClass(value: "C")
        let weakArray = WeakArray(objects: obj1, obj2!, obj3)
        
        // Deallocate obj2
        obj2 = nil
        
        // Iterating should only include two values
        var characters = [Character]()
        
        weakArray.forEach {
            characters.append($0.value)
        }
        
        XCTAssertEqual(characters, ["A", "C"])
    }
    
    func testForInLoopDoesntIncludeNilValues() {
        
        // Make an array with 3 values
        let obj1 = AClass(value: "A")
        var obj2 = Optional.some(AClass(value: "B"))
        let obj3 = AClass(value: "C")
        let weakArray = WeakArray(objects: obj1, obj2!, obj3)
        
        // Deallocate obj2
        obj2 = nil
        
        // Iterating should only include two values
        var characters = [Character]()
        
        for item in weakArray {
            characters.append(item.value)
        }
        
        XCTAssertEqual(characters, ["A", "C"])
    }
    
}

private class AClass {
    let value: Character
    
    init(value: Character) {
        self.value = value
    }
}

