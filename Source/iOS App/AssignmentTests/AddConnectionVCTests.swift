//
//  AddConnectionVCTests.swift
//  Assignment
//
//  Created by Jitendra on 24/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import XCTest
@testable import Assignment

class AddConnectionVCTests: XCTestCase {
    
    var vc: AddConnectionVC!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "AddConnectionVC") as! AddConnectionVC
        vc.mainPerson = Person(with: NSNumber(value: 1001), name: "Harry Potter", dateOfBirth: nil, dateOfDeath: nil, sex: .male, relations: [])
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
        XCTAssert(vc.textfieldSSN.text == person1.ssn.stringValue, "'textfieldSSN' doesn't show right text")
        XCTAssert(vc.textfieldName.text == person1.name, "'textfieldName' doesn't show right text")
        XCTAssert(vc.textfieldDOB.text == "", "'textfieldDOB' doesn't show right text")
        XCTAssert(vc.textfieldDOD.text == "", "'textfieldDOD' doesn't show right text")
        XCTAssert(vc.buttonMale.isSelected, "'buttonMale' not highlighted")
        XCTAssert(!vc.buttonFemale.isSelected, "'buttonFemale' is highlighted")
        
        let person2 = Person(with: NSNumber(value: 1002), name: "Angelina Jolie", dateOfBirth: "1965-08-22", dateOfDeath: nil, sex: .female, relations: [])
        vc.updateUI(with: person2)
        XCTAssert(vc.textfieldSSN.text == person2.ssn.stringValue, "'textfieldSSN' doesn't show right text")
        XCTAssert(vc.textfieldName.text == person2.name, "'textfieldName' doesn't show right text")
        XCTAssert(vc.textfieldDOB.text == person2.dateBirth, "'textfieldDOB' doesn't show right text")
        XCTAssert(vc.textfieldDOD.text == "", "'textfieldDOD' doesn't show right text")
        XCTAssert(!vc.buttonMale.isSelected, "'buttonMale' is highlighted")
        XCTAssert(vc.buttonFemale.isSelected, "'buttonFemale' not highlighted")

        let person3 = Person(with: NSNumber(value: 1002), name: "Unknown Gender", dateOfBirth: nil, dateOfDeath: "1965-08-22", sex: .unknown, relations: [])
        vc.updateUI(with: person3)
        XCTAssert(vc.textfieldSSN.text == person3.ssn.stringValue, "'textfieldSSN' doesn't show right text")
        XCTAssert(vc.textfieldName.text == person3.name, "'textfieldName' doesn't show right text")
        XCTAssert(vc.textfieldDOB.text == "", "'textfieldDOB' doesn't show right text")
        XCTAssert(vc.textfieldDOD.text == person3.dateDeath, "'textfieldDOD' doesn't show right text")
        XCTAssert(!vc.buttonMale.isSelected, "'buttonMale' is highlighted")
        XCTAssert(!vc.buttonFemale.isSelected, "'buttonFemale' is highlighted")
    }
    
    func testValidateDataWhileAddingRoot() {
        
        vc.inputMode = .addingRoot

        vc.textfieldSSN.text = "abcd"
        XCTAssertFalse(vc.validateData())
        
        vc.textfieldName.text = "1234"
        XCTAssertFalse(vc.validateData())

        vc.textfieldName.text = nil
        XCTAssertFalse(vc.validateData())

        vc.textfieldSSN.text = "abcd"
        vc.textfieldName.text = "1234"
        XCTAssertFalse(vc.validateData())
        
        vc.textfieldSSN.text = "1234"
        vc.textfieldName.text = "Harry Potter"
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "XXXXXXX"
        vc.textfieldName.text = "123456"
        XCTAssertFalse(vc.validateData())
        
        vc.textfieldSSN.text = "00000.00"
        vc.textfieldName.text = "Harry"
        XCTAssertFalse(vc.validateData())
        
        vc.textfieldSSN.text = "1"
        vc.textfieldName.text = "1"
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "12"
        vc.textfieldName.text = "Harry.Potter"
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "12"
        vc.textfieldName.text = "Harry.Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = nil
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "12"
        vc.textfieldName.text = "Harry.Potter"
        vc.selectedDOB = Date()
        vc.selectedDOD = nil
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = Date()
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = Date().addingTimeInterval(-7*24*60*60)     //Subtracting 7 days
        XCTAssertTrue(vc.validateData())
        
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = Date()
        vc.selectedDOD = Date().addingTimeInterval(-7*24*60*60)
        XCTAssertFalse(vc.validateData())
        
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = Date().addingTimeInterval(-7*24*60*60)
        vc.selectedDOD = Date()
        XCTAssertTrue(vc.validateData())
    }
    
    func testValidateDataWhileAddingRelation() {
        
        vc.inputMode = .addingRelation
        
        vc.selectedRelation = .father
        vc.textfieldSSN.text = "1234"
        vc.textfieldName.text = "Harry Potter"
        XCTAssertTrue(vc.validateData())
        
        vc.selectedRelation = nil
        vc.textfieldSSN.text = "1234"
        vc.textfieldName.text = "Harry Potter"
        XCTAssertFalse(vc.validateData())
        
        vc.selectedRelation = .boyFriend
        vc.textfieldSSN.text = "12"
        vc.textfieldName.text = "Harry.Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = nil
        XCTAssertTrue(vc.validateData())
        
        vc.selectedRelation = .mother
        vc.textfieldSSN.text = "12"
        vc.textfieldName.text = "Harry.Potter"
        vc.selectedDOB = Date()
        vc.selectedDOD = nil
        XCTAssertTrue(vc.validateData())
        
        vc.selectedRelation = .brother
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = Date()
        XCTAssertTrue(vc.validateData())
        
        vc.selectedRelation = .sister
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = nil
        vc.selectedDOD = Date().addingTimeInterval(-7*24*60*60)     //Subtracting 7 days
        XCTAssertTrue(vc.validateData())
        
        vc.selectedRelation = .uncle
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = Date()
        vc.selectedDOD = Date().addingTimeInterval(-7*24*60*60)
        XCTAssertFalse(vc.validateData())
        
        vc.selectedRelation = .aunt
        vc.textfieldSSN.text = "123"
        vc.textfieldName.text = "Harry Potter"
        vc.selectedDOB = Date().addingTimeInterval(-7*24*60*60)
        vc.selectedDOD = Date()
        XCTAssertTrue(vc.validateData())
    }
    
    func testDatePickerChange() {
        
        let date = Date()
        
        let datePicker1 = UIDatePicker()
        datePicker1.tag = 1
        datePicker1.date = date
        vc.datePickerChanged(sender: datePicker1)
        XCTAssert(vc.selectedDOB == date, "'selectedDOB' has incorrect value")
        XCTAssert(vc.textfieldDOB.text == vc.dateFormatter.string(from: date), "'textfieldDOB' has incorrect value")
        
        let datePicker2 = UIDatePicker()
        datePicker2.tag = 2
        datePicker2.date = date
        vc.datePickerChanged(sender: datePicker2)
        XCTAssert(vc.selectedDOD == date, "'selectedDOD' has incorrect value")
        XCTAssert(vc.textfieldDOD.text == vc.dateFormatter.string(from: date), "'textfieldDOD' has incorrect value")
    }
}
