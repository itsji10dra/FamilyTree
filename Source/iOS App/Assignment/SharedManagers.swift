//
//  DataManager.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    static let shared = DataManager()
    
    var rootPerson: Person?
    
    var lastLoadedSSN: NSNumber? {
        set { UserDefaults.standard.set(newValue, forKey: kSavedSSNKey) }
        get { return UserDefaults.standard.value(forKey: kSavedSSNKey) as? NSNumber }
    }
}

@objc
protocol NetworkDelegate: class {
    
    //Receiving Info
    @objc optional func willReceivePersonInfo(with ssnId: NSNumber)
    @objc optional func didReceivePersonInfo(with ssnId: NSNumber, person: Person)
    @objc optional func didReceiveErrorWhileReceiveingPersonInfo(with ssnId: NSNumber, error: Error?)
    
    //Adding New Root
    @objc optional func willStartAddingPersonInfo(with ssnId: NSNumber)
    @objc optional func didAddedPersonInfo(with ssnId: NSNumber, person: Person)
    @objc optional func didReceiveErrorWhileAddingPersonInfo(with ssnId: NSNumber, error: Error?)
    
    //Adding New Relation
    @objc optional func willStartAddingRelationInfo(for person: Person, with relation: RelationType, to newPerson: Person)
    @objc optional func didAddedRelationInfo(for person: Person, with relation: RelationType, to newPerson: Person)
    @objc optional func didReceiveErrorWhileAddingRelationInfo(for person: Person, error: Error?)
    
    //Deleting Relations
    @objc optional func willStartDeletingPersonInfo(with ssnId: NSNumber)
    @objc optional func didDeletedPersonInfo(with ssnId: NSNumber)
    @objc optional func didReceiveErrorWhileDeletingPersonInfo(with ssnId: NSNumber, error: Error?)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    weak var delegate: NetworkDelegate?
    
    //MARK: - Receiving Info
    
    func loadPersonInfo(with ssnId: NSNumber) {
        
        self.delegate?.willReceivePersonInfo?(with: ssnId)
        
        let parameters: Parameters = ["ssn": ssnId.stringValue]
        
        Alamofire.request(personAPI, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result
            {
                case .success:
                    if let json = response.result.value as? [String:AnyObject],
                        let status = json["status"] as? String {
                        
                        if status == kSuccess,
                            let personInfo = json["person"] as? [String:AnyObject] {
                            
                            let person = Person(with: personInfo)
                            DispatchQueue.main.async {
                                self.delegate?.didReceivePersonInfo?(with: ssnId, person: person)
                            }
                        }
                        else {
                            var error: CustomError?
                            
                            if let errorMessage = json["message"] as? String {
                                error = CustomError(localizedDescription: errorMessage)
                            }
                            
                            DispatchQueue.main.async {
                                self.delegate?.didReceiveErrorWhileReceiveingPersonInfo?(with: ssnId, error: error)
                            }
                        }
                    }
                
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveErrorWhileReceiveingPersonInfo?(with: ssnId, error: error)
                    }
            }
        }
    }
    
    //MARK: - Adding New Root
    
    func addInfo(for person: Person) {

        delegate?.willStartAddingPersonInfo?(with: person.ssn)
        
        let personInfo = ["ssn"     : person.ssn.stringValue,
                          "name"    : person.name,
                          "dob"     : person.dateBirth ?? "",
                          "dod"     : person.dateDeath ?? "",
                          "sex"     : person.sex.rawValue] as [String : Any]
        
        let parameters: Parameters = ["person": personInfo]
        
        Alamofire.request(personAPI, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let json = response.result.value as? [String:AnyObject],
                    let status = json["status"] as? String {
                    
                    DispatchQueue.main.async {
                        if status == kSuccess {
                            self.delegate?.didAddedPersonInfo?(with: person.ssn, person: person)
                        }
                        else {
                            self.delegate?.didReceiveErrorWhileAddingPersonInfo?(with: person.ssn, error: nil)
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didReceiveErrorWhileAddingPersonInfo?(with: person.ssn, error: error)
                }
            }
        }
    }
    
    //MARK: - Adding New Relation
    
    func addRelation(for person: Person, in relation: RelationType, toNewPerson: Person) {
        
        self.delegate?.willStartAddingRelationInfo?(for: person, with: relation, to: toNewPerson)

        let relationInfo = ["relation" : relation.rawValue,
                            "person"   : person.ssn] as [String : Any]
        
        let personInfo = ["ssn"     : toNewPerson.ssn.stringValue,
                          "name"    : toNewPerson.name,
                          "dob"     : toNewPerson.dateBirth ?? "",
                          "dod"     : toNewPerson.dateDeath ?? "",
                          "sex"     : toNewPerson.sex.rawValue,
                          "relationships" : relationInfo] as [String : Any]
        
        let parameters: Parameters = ["person": personInfo]

        Alamofire.request(personAPI, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result
            {
                case .success:
                    if let json = response.result.value as? [String:AnyObject],
                        let status = json["status"] as? String {
                        
                        DispatchQueue.main.async {
                            if status == kSuccess {
                                self.delegate?.didAddedRelationInfo?(for: person, with: relation, to: toNewPerson)
                            }
                            else {
                                self.delegate?.didReceiveErrorWhileAddingRelationInfo?(for: person, error: nil)
                            }
                        }
                    }
                
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveErrorWhileAddingRelationInfo?(for: person, error: error)
                    }
            }
        }
    }
    
    //MARK: - Deleting Relations
    
    func deletePersonInfo(with ssnId: NSNumber) {

        self.delegate?.willStartDeletingPersonInfo?(with: ssnId)
        
        let deleteURL = personAPI + ssnId.stringValue + "/"
        
        Alamofire.request(deleteURL, method: .delete).responseJSON { response in
            
            DispatchQueue.main.async {
                if response.response?.statusCode == 204 {
                        self.delegate?.didDeletedPersonInfo?(with: ssnId)
                }
                else {
                    let error = response.result.error
                    self.delegate?.didReceiveErrorWhileReceiveingPersonInfo?(with: ssnId, error: error)
                }
            }
        }
    }
}
