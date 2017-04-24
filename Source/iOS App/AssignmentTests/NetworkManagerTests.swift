//
//  NetworkManager.swift
//  Assignment
//
//  Created by Jitendra on 24/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import XCTest

class SpyNetworkDelegate: NetworkDelegate {
    
    var returnedPerson: Person? = nil
    
    var asyncExpectation: XCTestExpectation?
    
    func didReceivePersonInfo(with ssnId: NSNumber, person: Person) {
        guard let expectation = asyncExpectation else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }

        returnedPerson = person
        expectation.fulfill()
    }
}

class NetworkManagerTests: XCTestCase {
    
    var rootVC: RootInfoRootVC!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootVC = storyboard.instantiateViewController(withIdentifier: "RootInfoRootVC") as! RootInfoRootVC
        let _ = rootVC.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        rootVC = nil
    }
    
    func testLoadPersonInfoTest() {
        
        let spyDelegate = SpyNetworkDelegate()
        let network = NetworkManager.shared
        network.delegate = spyDelegate

        let expect = expectation(description: "RootInfoRootVC calls the delegate as the result of an async method completion")
        spyDelegate.asyncExpectation = expect
        
        let number = NSNumber(value: 1001)
        rootVC.loadData(with: number)
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let person = spyDelegate.returnedPerson else {
                XCTFail("Expected delegate to be called")
                return
            }
            
            XCTAssertTrue(person.ssn == number)
            
        }
    }
}
