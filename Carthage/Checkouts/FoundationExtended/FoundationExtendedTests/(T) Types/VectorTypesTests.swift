//
//  VectorTypesTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 08/03/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class VectorTypesTests: XCTestCase {
    
    // MARK: - Test Vector 2
    
    func testVector2SetCorrectValuesWithDefaultInitializer() {
        
        let v = Vector2(1, 2)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
    }
    
    func testVector2SetCorrectValuesWithXYInitializer() {
        
        let v = Vector2(x: 1, y: 2)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
    }
    
    func testVector2GetCorrectValuesWithXYGetters() {
        
        let v = Vector2(1, 2)
        XCTAssertEqual(v.x, 1)
        XCTAssertEqual(v.y, 2)
    }
    
    func testVector2SetCorrectValuesWithXYSetters() {
        
        var v = Vector2(0, 0)
        v.x = 10
        v.y = 11
        XCTAssertEqual(v.v0, 10)
        XCTAssertEqual(v.v1, 11)
    }
    
    // MARK: - Test Vector 3
    
    func testVector3SetCorrectValuesWithDefaultInitializer() {
        
        let v = Vector3(1, 2, 3)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
    }
    
    func testVector3SetCorrectValuesWithXYZInitializer() {
        
        let v = Vector3(x: 1, y: 2, z: 3)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
    }
    
    func testVector3GetCorrectValuesWithXYZGetters() {
        
        let v = Vector3(1, 2, 3)
        XCTAssertEqual(v.x, 1)
        XCTAssertEqual(v.y, 2)
        XCTAssertEqual(v.z, 3)
    }
    
    func testVector3SetCorrectValuesWithXYZSetters() {
        
        var v = Vector3(0, 0, 0)
        v.x = 1
        v.y = 2
        v.z = 3
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
    }
    
    func testVector3SetCorrectValuesWithRGBInitializer() {
        
        let v = Vector3(r: 1, g: 2, b: 3)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
    }
    
    func testVector3GetCorrectValuesWithRGBGetters() {
        
        let v = Vector3(1, 2, 3)
        XCTAssertEqual(v.r, 1)
        XCTAssertEqual(v.g, 2)
        XCTAssertEqual(v.b, 3)
    }
    
    func testVector3SetCorrectValuesWithRGBSetters() {
        
        var v = Vector3(0, 0, 0)
        v.r = 1
        v.g = 2
        v.b = 3
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
    }
    
    // MARK: - Test Vector 4
    
    func testVector4SetCorrectValuesWithDefaultInitializer() {
        
        let v = Vector4(1, 2, 3, 4)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
        XCTAssertEqual(v.v3, 4)
    }
    
    func testVector4SetCorrectValuesWithXYZWInitializer() {
        
        let v = Vector4(x: 1, y: 2, z: 3, w: 4)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
        XCTAssertEqual(v.v3, 4)
    }
    
    func testVector4GetCorrectValuesWithXYZWGetters() {
        
        let v = Vector4(1, 2, 3, 4)
        XCTAssertEqual(v.x, 1)
        XCTAssertEqual(v.y, 2)
        XCTAssertEqual(v.z, 3)
        XCTAssertEqual(v.w, 4)
    }
    
    func testVector4SetCorrectValuesWithXYZWSetters() {
        
        var v = Vector4(0, 0, 0, 0)
        v.x = 1
        v.y = 2
        v.z = 3
        v.w = 4
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
        XCTAssertEqual(v.v3, 4)
    }
    
    func testVector4SetCorrectValuesWithRGBAInitializer() {
        
        let v = Vector4(r: 1, g: 2, b: 3, a: 4)
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
        XCTAssertEqual(v.v3, 4)
    }
    
    func testVector4GetCorrectValuesWithRGBAGetters() {
        
        let v = Vector4(1, 2, 3, 4)
        XCTAssertEqual(v.r, 1)
        XCTAssertEqual(v.g, 2)
        XCTAssertEqual(v.b, 3)
        XCTAssertEqual(v.a, 4)
    }
    
    func testVector4SetCorrectValuesWithRGBASetters() {
        
        var v = Vector4(0, 0, 0, 0)
        v.r = 1
        v.g = 2
        v.b = 3
        v.a = 4
        XCTAssertEqual(v.v0, 1)
        XCTAssertEqual(v.v1, 2)
        XCTAssertEqual(v.v2, 3)
        XCTAssertEqual(v.v3, 4)
    }
    
}
