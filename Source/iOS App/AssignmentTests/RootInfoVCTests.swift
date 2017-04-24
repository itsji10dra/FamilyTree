//
//  RootInfoVCTests.swift
//  Assignment
//
//  Created by Jitendra on 24/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import XCTest
@testable import Assignment

class RootInfoVCTests: XCTestCase {
    
    var vc: RootInfoVC!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "RootInfoVC") as! RootInfoVC
        let _ = vc.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        vc = nil
    }
    
    func testUpdateUI() {
        
        let person1 = Person(with: NSNumber(value: 1002), name: "Tom Cruise", dateOfBirth: nil, dateOfDeath: nil, sex: .male, relations: [])
        vc.updateUI(with: person1)
        XCTAssert(vc.labelSSN.text == person1.ssn.stringValue, "'labelSSN' doesn't show right text")
        XCTAssert(vc.labelName.text == person1.name, "'labelName' doesn't show right text")
        XCTAssert(vc.labelDateOfBirth.text == kNotAvailable, "'labelDateOfBirth' doesn't show right text")
        XCTAssert(vc.labelDateOfDeath.text == kNotAvailable, "'labelDateOfDeath' doesn't show right text")
        XCTAssert(vc.labelSex.text == person1.sex.stringValue, "'labelSex' doesn't show right text")
        XCTAssert(vc.labelNoOfRelations.text == String(person1.relationships.count), "'labelNoOfRelations' doesn't show right text")
        
        let person2 = Person(with: NSNumber(value: 1002), name: "Angelina Jolie", dateOfBirth: "1965-08-22", dateOfDeath: nil, sex: .female, relations: [])
        vc.updateUI(with: person2)
        XCTAssert(vc.labelSSN.text == person2.ssn.stringValue, "'labelSSN' doesn't show right text")
        XCTAssert(vc.labelName.text == person2.name, "'labelName' doesn't show right text")
        XCTAssert(vc.labelDateOfBirth.text == person2.dateBirth, "'labelDateOfBirth' doesn't show right text")
        XCTAssert(vc.labelDateOfDeath.text == kNotAvailable, "'labelDateOfDeath' doesn't show right text")
        XCTAssert(vc.labelSex.text == person2.sex.stringValue, "'labelSex' doesn't show right text")
        XCTAssert(vc.labelNoOfRelations.text == String(person2.relationships.count), "'labelNoOfRelations' doesn't show right text")
        
        let person3 = Person(with: NSNumber(value: 1002), name: "Unknown Gender", dateOfBirth: nil, dateOfDeath: "1965-08-22", sex: .unknown, relations: [])
        vc.updateUI(with: person3)
        XCTAssert(vc.labelSSN.text == person3.ssn.stringValue, "'labelSSN' doesn't show right text")
        XCTAssert(vc.labelName.text == person3.name, "'labelName' doesn't show right text")
        XCTAssert(vc.labelDateOfBirth.text == kNotAvailable, "'labelDateOfBirth' doesn't show right text")
        XCTAssert(vc.labelDateOfDeath.text == person3.dateDeath, "'labelDateOfDeath' doesn't show right text")
        XCTAssert(vc.labelSex.text == person3.sex.stringValue, "'labelSex' doesn't show right text")
        XCTAssert(vc.labelNoOfRelations.text == String(person3.relationships.count), "'labelNoOfRelations' doesn't show right text")
    }
}
