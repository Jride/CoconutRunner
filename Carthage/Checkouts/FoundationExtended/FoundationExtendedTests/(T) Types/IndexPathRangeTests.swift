//
//  IndexPathRangeTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 18/10/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class IndexPathRangeTests: XCTestCase {
    
    func testIndexPathRangeWithSingleSectionAndSingleItem() {
        
        let range = IndexPathRange(startSection: 1, startItem: 3, endSection: 1, endItem: 3)
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 2, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 3, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 4, section: 1)))
    }

    func testIndexPathRangeWithSingleSectionAndMultipleItems() {
        
        let range = IndexPathRange(startSection: 1, startItem: 3, endSection: 1, endItem: 5)
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 1, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 2, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 3, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 4, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 5, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 6, section: 0)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 7, section: 0)))
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 2, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 3, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 4, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 5, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 6, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 7, section: 1)))
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 1, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 2, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 3, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 4, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 5, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 6, section: 2)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 7, section: 2)))
    }
    
    func testIndexPathRangeWithMultipleSectionsAndMultipleItems() {
        
        let range = IndexPathRange(startSection: 1, startItem: 5, endSection: 3, endItem: 3)
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 0, section: 0)))
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 3, section: 1)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 4, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 5, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 6, section: 1)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 7, section: 1)))
        
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 0, section: 2)))
        
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 1, section: 3)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 2, section: 3)))
        XCTAssertTrue(range.contains(indexPath: IndexPath(row: 3, section: 3)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 4, section: 3)))
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 5, section: 3)))
        
        XCTAssertFalse(range.contains(indexPath: IndexPath(row: 3, section: 4)))
    }

}
