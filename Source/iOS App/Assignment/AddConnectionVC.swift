//
//  AddConnectionVC.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol AddConnectionDelegate: class {
    func dataDidUpdated(updated: Bool)
}

class AddConnectionVC: UIViewController, NetworkDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - IBOutlets 
    
    @IBOutlet weak var stackViewRelationInfo: UIStackView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var textfieldRelation: UITextField!
    @IBOutlet weak var textfieldSSN: UITextField!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldDOB: UITextField!
    @IBOutlet weak var textfieldDOD: UITextField!
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    @IBOutlet var collectionButtonGenders: [UIButton]!

    // MARK: - Data
    
    var inputMode: InputMode = .addingRelation
    var mainPerson: Person!
    weak var delegate: AddConnectionDelegate?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()

    var selectedRelation: RelationType? {
        didSet {
            textfieldRelation.text = selectedRelation?.stringValue
        }
    }
    var selectedDOB: Date? {
        didSet {
            textfieldDOB.text = selectedDOB != nil ? dateFormatter.string(from: selectedDOB!) : nil
        }
    }
    var selectedDOD: Date? {
        didSet {
            textfieldDOD.text = selectedDOD != nil ? dateFormatter.string(from: selectedDOD!) : nil
        }
    }
    var selectedGender: Sex {
        if buttonMale.isSelected    { return .male     }
        if buttonFemale.isSelected  { return .female   }
        return .unknown
    }
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customiseUI()
        configureInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    private func customiseUI() {
        
        if inputMode == .addingRelation {
            title = "Add Relation"
            labelInfo.text = "Fill in details for " + mainPerson.name + "'s " + "new relation."
        }
        else {
            title = "Add Root Person"
            labelInfo.text = "Fill in details for root person."
            stackViewRelationInfo.isHidden = true
        }
    }
    
    private func configureInputViews() {
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        textfieldRelation.inputView = pickerView
        
        let datePickerBirth = UIDatePicker()
        datePickerBirth.tag = 1
        datePickerBirth.maximumDate = Date()
        datePickerBirth.datePickerMode = .date
        textfieldDOB.inputView = datePickerBirth
        
        let datePickerDeath = UIDatePicker()
        datePickerDeath.tag = 2
        datePickerDeath.maximumDate = Date()
        datePickerDeath.datePickerMode = .date
        textfieldDOD.inputView = datePickerDeath

        datePickerDeath.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        datePickerBirth.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }

    // MARK: - Internal Methods

    internal func updateUI(with person: Person) {
        
        textfieldSSN.text = person.ssn.stringValue
        textfieldName.text = person.name
        textfieldDOB.text = person.dateBirth
        textfieldDOD.text = person.dateDeath
        buttonMale.isSelected = person.sex == .male
        buttonFemale.isSelected = person.sex == .female
    }

    internal func validateData() -> Bool {
     
        if inputMode == .addingRelation && selectedRelation == nil {
            Message.showErrorMessage(text: "Please select relation.")
            return false
        }
        
        guard let ssnText = textfieldSSN.text, !ssnText.isEmpty,
            let _ = Int(ssnText) else {
            Message.showErrorMessage(text: "Please fill in valid SSN.")
            return false
        }
        
        guard let nameText = textfieldName.text, !nameText.isEmpty else {
            Message.showErrorMessage(text: "Please fill in Name.")
            return false
        }
        
        if let dateBirth = selectedDOB, let dateDeath = selectedDOD,
            dateBirth > dateDeath {
            Message.showErrorMessage(text: "Date of birth cant be earlier than date of death.")
            return false
        }
                
        return true
    }

    @objc
    internal func datePickerChanged(sender: UIDatePicker) {
        
        sender.tag == 1 ? (selectedDOB = sender.date) : (selectedDOD = sender.date)
    }
    
    // MARK: - IBOutlets Action

    @IBAction func genderButtonAction(_ sender: UIButton) {
        
        collectionButtonGenders.forEach { $0.isSelected = false }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if validateData() {
            
            let ssnNumber = NSNumber(integerLiteral: Int(textfieldSSN.text!)!)
            let name = textfieldName.text!
            let dateOfBirth = selectedDOB != nil ? textfieldDOB.text : ""
            let dateOfDeath = selectedDOD != nil ? textfieldDOD.text : ""
            let sex = selectedGender
            
            let newPerson = Person(with: ssnNumber, name: name, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, sex: sex, relations: [])
            
            let networkManager = NetworkManager.shared
            networkManager.delegate = self
            
            if inputMode == .addingRelation {
                networkManager.addRelation(for: mainPerson, in: selectedRelation!, toNewPerson: newPerson)
            }
            else {
                networkManager.addInfo(for: newPerson)
            }
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        dismiss(animated: true, completion: {
            self.delegate?.dataDidUpdated(updated: false)
        })
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfieldSSN    { return textfieldName.becomeFirstResponder() }
        if textField == textfieldName   { return textfieldDOB.becomeFirstResponder()  }
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == textfieldSSN,
            let text = textField.text,
            let ssnInteger = Int(text) {
                
            let networkManager = NetworkManager.shared
            networkManager.delegate = self
            networkManager.loadPersonInfo(with: NSNumber(value: ssnInteger))
        }
    }

    //MARK: - UIPicketViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RelationType.allTypes.count
    }
    
    //MARK: - UIPicketViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RelationType.allTypes[row].stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRelation = RelationType.allTypes[row]
    }
    
    //MARK: - NetworkDelegate - Receiving Info
    
    func willReceivePersonInfo(with ssnId: NSNumber) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func didReceivePersonInfo(with ssnId: NSNumber, person: Person) {
        MBProgressHUD.hide(for: view, animated: true)
        
        if inputMode == .addingRelation {
            updateUI(with: person)
        }
        else if inputMode == .addingRoot {
            Message.showErrorMessage(text: "SSN Id already exist. Kindly go back & chose 'Existing User' from options.")
        }
    }
    
    func didReceiveErrorWhileReceiveingPersonInfo(with ssnId: NSNumber, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)
        
        print(#function, error ?? "")
    }
    
    //MARK: - NetworkDelegate - Adding New Root
    
    func willStartAddingPersonInfo(with ssnId: NSNumber) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func didAddedPersonInfo(with ssnId: NSNumber, person: Person) {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        if inputMode == .addingRoot
        {
            let dataManager = DataManager.shared
            dataManager.lastLoadedSSN = ssnId
            dataManager.rootPerson = person
        }
        
        dismiss(animated: true, completion: {
            self.delegate?.dataDidUpdated(updated: true)
        })
    }
    
    func didReceiveErrorWhileAddingPersonInfo(with ssnId: NSNumber, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)
        
        if error != nil {
            var message: String = error!.localizedDescription
            
            if let error = error as? CustomError {
                message = error.localizedDescription
            }
            
            Message.showErrorMessage(text: message)
        }
    }
    
    //MARK: - NetworkDelegate - Adding New Relation
    
    func willStartAddingRelationInfo(for person: Person, with relation: RelationType, to newPerson: Person) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func didAddedRelationInfo(for person: Person, with relation: RelationType, to newPerson: Person) {
        MBProgressHUD.hide(for: view, animated: true)
        dismiss(animated: true, completion: {
            self.delegate?.dataDidUpdated(updated: true)
        })
    }
    
    func didReceiveErrorWhileAddingRelationInfo(for person: Person, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)

        if error != nil {
            var message: String = error!.localizedDescription
            
            if let error = error as? CustomError {
                message = error.localizedDescription
            }
            
            Message.showErrorMessage(text: message)
        }
    }
}
