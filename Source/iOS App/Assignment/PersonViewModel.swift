//
//  PersonViewModel.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import Foundation

class PersonViewModel: Person {

    var generation: Int!
    var isOpened: Bool!
    var isRoot: Bool!
    var relationType: RelationType?
    var relationId: NSNumber?
    
    var hasRelations: Bool {
        return !self.relationships.isEmpty
    }
        
    init(with person: Person, generation: Int = 0, isOpen: Bool = false, isRoot: Bool = false, relationType: RelationType? = nil, relationId: NSNumber? = nil) {
        
        super.init(with: person.ssn, name: person.name, dateOfBirth: person.dateBirth, dateOfDeath: person.dateDeath, sex: person.sex, relations: person.relationships)
        
        self.generation = generation
        self.isOpened = isOpen
        self.isRoot = isRoot
        self.relationType = relationType
        self.relationId = relationId
    }
    
    func getAllRelations(level: Int) -> [PersonViewModel] {
        
        var subModels = [PersonViewModel]()
        
        for relation in self.relationships {
            let personModel = PersonViewModel(with: relation.person, generation: level, isOpen: false, isRoot: false, relationType: relation.relationType, relationId: relation.relationId)
            subModels.append(personModel)
        }
        
        return subModels
    }
}
