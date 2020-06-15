//
//  FileManager+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 10/04/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class FileManager_ExtensionsTests: XCTestCase {
    
    enum DataSet {
        case oneKB, twoKB, sixKB
        
        var url: URL {
            
            let bundle = Bundle(for: FileManager_ExtensionsTests.self)
            
            switch self {
            case .oneKB: return bundle.url(forResource: "1KB_data_set", withExtension: "txt").require("")
            case .twoKB: return bundle.url(forResource: "2KB_data_set", withExtension: "txt").require("")
            case .sixKB: return bundle.url(forResource: "6KB_data_set", withExtension: "txt").require("")
            }
        }
    }
    
    var tempDir: URL!
    let fileManager = FileManager.default

    override func setUp() {
        
        tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("UNIT_TEST")
        
        removeTempFolderIfNecessary()
        
        // Create our temp directory
        createDir(atPath: tempDir.path)
    }

    func test_WhenDirectoryContains3KBOfData_ThenSizeOfDirectoryIsCalculatedCorrectly() {
        
        copyDataSet(.oneKB, to: tempDir.appendingPathComponent("testDataSet1.txt"))
        copyDataSet(.twoKB, to: tempDir.appendingPathComponent("testDataSet2.txt"))
        
        let size = (try? fileManager.sizeOfDirectory(at: tempDir)).require("Unable to calculate size of directory")
        
        XCTAssertEqual(size, 3000)
    }
    
    func test_WhenDirectoryContains9KBOfData_ThenSizeOfDirectoryIsCalculatedCorrectly() {
        
        copyDataSet(.oneKB, to: tempDir.appendingPathComponent("testDataSet1.txt"))
        copyDataSet(.twoKB, to: tempDir.appendingPathComponent("testDataSet2.txt"))
        copyDataSet(.sixKB, to: tempDir.appendingPathComponent("testDataSet3.txt"))
        
        let size = (try? fileManager.sizeOfDirectory(at: tempDir)).require("Unable to calculate size of directory")
        
        XCTAssertEqual(size, 9000)
    }
    
    func test_WhenDirectoryContainsSubFolder_ThenSizeOfDirectoryIsCalculatedCorrectly() {
        
        copyDataSet(.oneKB, to: tempDir.appendingPathComponent("testDataSet1.txt"))
        copyDataSet(.twoKB, to: tempDir.appendingPathComponent("testDataSet2.txt"))
        copyDataSet(.sixKB, to: tempDir.appendingPathComponent("testDataSet3.txt"))
        
        let subDir = tempDir.appendingPathComponent("subdir")
        createDir(atPath: subDir.path)
        copyDataSet(.twoKB, to: subDir.appendingPathComponent("testDataSet4.txt"))
        copyDataSet(.twoKB, to: subDir.appendingPathComponent("testDataSet5.txt"))
        
        let size = (try? fileManager.sizeOfDirectory(at: tempDir)).require("Unable to calculate size of directory")
        
        XCTAssertEqual(size, 13000)
    }
    
    func test_WhenDirectoryContainsMultipleSubFolders_ThenSizeOfDirectoryIsCalculatedCorrectly() {
        
        copyDataSet(.oneKB, to: tempDir.appendingPathComponent("testDataSet1.txt"))
        copyDataSet(.twoKB, to: tempDir.appendingPathComponent("testDataSet2.txt"))
        copyDataSet(.sixKB, to: tempDir.appendingPathComponent("testDataSet3.txt"))
        
        let subDir = tempDir.appendingPathComponent("subdir")
        createDir(atPath: subDir.path)
        copyDataSet(.twoKB, to: subDir.appendingPathComponent("testDataSet4.txt"))
        copyDataSet(.twoKB, to: subDir.appendingPathComponent("testDataSet5.txt"))
        
        let subSubDir = tempDir.appendingPathComponent("subSubDir")
        createDir(atPath: subSubDir.path)
        copyDataSet(.oneKB, to: subSubDir.appendingPathComponent("testDataSet6.txt"))
        copyDataSet(.sixKB, to: subSubDir.appendingPathComponent("testDataSet7.txt"))
        
        let size = (try? fileManager.sizeOfDirectory(at: tempDir)).require("Unable to calculate size of directory")
        
        XCTAssertEqual(size, 20000)
    }

}

extension FileManager_ExtensionsTests {
    
    private func createDir(atPath path: String, file: StaticString = #file, line: UInt = #line) {
        do {
            try fileManager
                .createDirectory(atPath: path,
                                 withIntermediateDirectories: true,
                                 attributes: nil)
        } catch let error {
            XCTFail("\(error)", file: file, line: line)
        }
    }
    
    private func copyDataSet(_ dataSet: DataSet, to: URL, file: StaticString = #file, line: UInt = #line) {
        
        do {
            try fileManager.copyItem(at: dataSet.url, to: to)
        } catch let error {
            XCTFail("\(error)", file: file, line: line)
        }
    }
    
    private func removeTempFolderIfNecessary(file: StaticString = #file, line: UInt = #line) {
        
        guard fileManager.fileExists(atPath: tempDir.path) else { return }
        
        do {
            try fileManager.removeItem(at: tempDir)
        } catch let error {
            XCTFail("\(error)", file: file, line: line)
        }
    }
    
}
