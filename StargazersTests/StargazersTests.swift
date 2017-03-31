//
//  StargazersTests.swift
//  StargazersTests
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import XCTest
@testable import Stargazers

class StargazersTests: XCTestCase {
	var owner : String!
	var repo : String!
	
    override func setUp() {
        super.setUp()
		owner = "matteocrippa"
		repo = "awesome-swift"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescription() {
		let formViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
		let descriptionExpectation = expectation(description: "description")
		
		formViewController.checkRepo(owner: owner, repo: repo) { ok, JSON in
			XCTAssert(ok, "Unable to check repo")
			descriptionExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 3) { error in
			XCTAssertNil(error, "GitHub Repo Description Timeout")
		}
    }
	
	func testStargazers() {
		let stargazersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StargazersTableViewController") as! StargazersTableViewController
		let stargazersExpectation = expectation(description: "stargazers")
		stargazersViewController.owner = owner
		stargazersViewController.repo = repo
		
		stargazersViewController.loadNextPage() { ok in
			XCTAssert(ok, "Unable to load Stargazers")
			stargazersExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 3) { error in
			XCTAssertNil(error, "GitHub Stargazers Timeout")
		}
	}
	
	
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
