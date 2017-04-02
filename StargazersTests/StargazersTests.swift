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
		let descriptionExpectation = expectation(description: "description")
		
		StargazersSingleton.sharedInstance.useRepo(owner: owner, repo: repo) { response in
			switch response {
			case .ok(_):
				descriptionExpectation.fulfill()
			case .error(let message):
				XCTFail("Unable to use repo: \(message)")
				descriptionExpectation.fulfill()
			}
		}
		
		waitForExpectations(timeout: 3) { error in
			XCTAssertNil(error, "GitHub Repo Description Timeout")
		}
    }
	
	func testStargazers() {
		let stargazersExpectation = expectation(description: "stargazers")

		StargazersSingleton.sharedInstance.loadStargazersPage(currentPage: 1) { response in
			switch response {
			case .ok(_):
				stargazersExpectation.fulfill()
			case .error(let message):
				XCTFail("Unable to load Stargazers: \(message)")
				stargazersExpectation.fulfill()
			}
		}
		
		waitForExpectations(timeout: 3) { error in
			XCTAssertNil(error, "GitHub Stargazers Timeout")
		}
	}
}
