//
//  Annex_getTests.swift
//  Annex-getTests
//
//  Created by Carl Moden on 2015-07-21.
//  Copyright © 2015 Carl Moden.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import XCTest
@testable import Annex_get

class Annex_getTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class ModelTests: XCTestCase {
    let repo = Repository()
    let fileManager = NSFileManager.defaultManager()
    
    var tempRepo: NSURL?

    override func setUp() {
        super.setUp()
        let tempFolder = NSTemporaryDirectory()
        let unique = tempFolder + NSProcessInfo().globallyUniqueString
        self.tempRepo = NSURL(fileURLWithPath: unique, isDirectory: true)
        try! fileManager.createDirectoryAtURL(self.tempRepo!, withIntermediateDirectories: true, attributes: nil)
        print(self.tempRepo)
        
    }

    override func tearDown() {
        try! fileManager.removeItemAtURL(tempRepo!)
    }

    func testRepoRoot() {
        guard let repoPath = self.repo.repoRoot.path else {
            XCTFail("repoRoot is nil")
            return
        }
        XCTAssertTrue(repoPath.rangeOfString("Movies/Movies") != nil)
    }

    func testListFiles_NoFilesThere() {
        XCTAssertEqual((self.repo.listFiles(self.tempRepo!)).count, 0)
    }
    
    func testListFiles_OnlyHiddenSubdir() {
        let filePath = NSURL(string: ".dir/", relativeToURL: self.tempRepo)
        try! fileManager.createDirectoryAtURL(filePath!, withIntermediateDirectories: true, attributes: nil)
        XCTAssertEqual((self.repo.listFiles(self.tempRepo!)).count, 0)
    }
    
    func testListFiles_WithFiles() {
        let filePath = NSURL(string: "dir/", relativeToURL: self.tempRepo)
        print(filePath)
        try! fileManager.createDirectoryAtURL(filePath!, withIntermediateDirectories: true, attributes: nil)
        XCTAssertEqual((self.repo.listFiles(self.tempRepo!)).count, 1)
    }

}
