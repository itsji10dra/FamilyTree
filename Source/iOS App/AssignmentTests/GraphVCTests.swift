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
        
        let harryMother = Person(with: NSNumber(value: 1001), name: "Lily Potter", dateOfBirth: "1972-06-02", dateOfDeath: "1990-01-02", sex: .male, relations: [])
        
        let harryFather = Person(with: NSNumber(value: 1001), name: "James Potter", dateOfBirth: "1970-06-02", dateOfDeath: "1990-01-02", sex: .male, relations: [])
        
        let fatherRelation = Relationship(with: NSNumber(value: 5), type: .father, with: harryFather)
        
        let motherRelation = Relationship(with: NSNumber(value: 6), type: .mother, with: harryMother)
        
        let rootPerson = Person(with: NSNumber(value: 1001), name: "Harry Potter", dateOfBirth: "1990-12-01", dateOfDeath: nil, sex: .male, relations: [fatherRelation, motherRelation])
        
        DataManager.shared.rootPerson = rootPerson
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        vc = nil
    }
    
    func testLoadDataSource() {
        
        vc.loadDataSource()
        
        let rows = vc.tableViewGraph.numberOfRows(inSection: 0) == 1
        XCTAssert(rows, "Invalid number of rows")
        
        vc.tableView(vc.tableViewGraph, didSelectRowAt: IndexPath(row: 0, section: 0))
        let expandedRows = vc.tableViewGraph.numberOfRows(inSection: 0) == 3
        XCTAssert(expandedRows, "Invalid number of rows")
    }
}
