//
//  Enums.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import Foundation

enum Sex: Int {
    
    case unknown = 0
    case male = 1
    case female = 2
    
    var stringValue: String {
        
        switch self
        {
            case .male      :   return "Male"
            case .female    :   return "Female"
            case .unknown   :   return "Unknown"
        }
    }
}

@objc
enum RelationType: Int {
    
    case father = 1
    case mother = 2
    case brother = 3
    case sister = 4
    case husband = 5
    case wife = 6
    case uncle = 7
    case aunt = 8
    case son = 9
    case daughter = 10
    case grandFather = 11
    case grandMother = 12
    case boyFriend = 13
    case girlFriend = 14
    
    static let allTypes: [RelationType] = [.father, .mother, .brother, .sister, .husband, .wife, .uncle, .aunt, .son, .daughter, .grandFather, .grandMother, .boyFriend, .girlFriend ]
    
    var stringValue: String {
        
        switch self
        {
            case .father        :   return "Father"
            case .mother        :   return "Mother"
            case .brother       :   return "Brother"
            case .sister        :   return "Sister"
            case .husband       :   return "Husband"
            case .wife          :   return "Wife"
            case .uncle         :   return "Uncle"
            case .aunt          :   return "Aunt"
            case .son           :   return "Son"
            case .daughter      :   return "Daughter"
            case .grandFather   :   return "Grand Father"
            case .grandMother   :   return "Grand Mother"
            case .boyFriend     :   return "Boy Friend"
            case .girlFriend    :   return "Girl Friend"
        }
    }
}

enum InputMode {
    case addingRoot
    case addingRelation
}

