//
//  Person.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import Foundation

class Person: NSObject {
    
    var ssn: NSNumber!
    var name: String!
    var dateBirth: String?
    var dateDeath: String?
    var sex: Sex = .unknown
    lazy var relationships = [Relationship]()
    
    init(with ssn: NSNumber, name: String, dateOfBirth: String? = nil, dateOfDeath: String? = nil, sex: Sex = .unknown, relations: [Relationship]) {
        
        super.init()
        
        self.ssn = ssn
        self.name = name
        self.dateBirth = dateOfBirth
        self.dateDeath = dateOfDeath
        self.sex = sex
        self.relationships = relations
    }
    
    convenience override init() {
        self.init(with: NSNumber(integerLiteral: 0), name: "", dateOfBirth: nil, dateOfDeath: nil, sex: .unknown, relations: [])
    }
    
    convenience init(with infoObject: [String:AnyObject]) {
        
        if let ssnInfo = infoObject["ssn"] as? NSNumber,
            let name = infoObject["name"] as? String {

            let dateBirth = infoObject["dob"] as? String
            let dateDeath = infoObject["dod"] as? String
            let sex = Sex(rawValue: (infoObject["sex"] as? NSNumber)?.intValue ?? 0) ?? .unknown
            
            var relationships: [Relationship] = []
            
            if let relationshipInfo = infoObject["relationships"] as? [[String:AnyObject]] {
                relationships = relationshipInfo.map {
                    return Relationship(with: $0)
                }
            }
            
            self.init(with: ssnInfo, name: name, dateOfBirth: dateBirth, dateOfDeath: dateDeath, sex: sex, relations: relationships)
        }
        else { fatalError("SSN Id not found") }
    }
}

class Relationship {
    
    var relationId: NSNumber!
    var relationType: RelationType!
    var person: Person!
    
    init(with infoObject: [String:AnyObject]) {
        
        if let id = infoObject["id"] as? NSNumber,
            let relation = infoObject["relation"] as? NSNumber,
            let personInfo = infoObject["person"] as? [String:AnyObject] {
            
            self.relationId = id
            self.relationType = RelationType(rawValue: relation.intValue)
            self.person = Person(with: personInfo)
        }
    }
}
