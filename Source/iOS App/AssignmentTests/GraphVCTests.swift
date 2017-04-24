//
//  GraphVCTests.swift
//  Assignment
//
//  Created by Jitendra on 24/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import XCTest
@testable import Assignment

class GraphVCTests: XCTestCase {
    
    var vc: GraphVC!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "GraphVC") as! GraphVC
        let _ = vc.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        vc = nil
    }
    
    func loadDataSourceTest() {
        
    }
}
