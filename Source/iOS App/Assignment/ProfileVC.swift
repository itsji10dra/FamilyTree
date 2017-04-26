//
//  ProfileVC.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileVC: UIViewController, NetworkDelegate, AddConnectionDelegate {

    //MARK: - IBOutlets

    @IBOutlet weak var labelSSN: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDateOfBirth: UILabel!
    @IBOutlet weak var labelDateOfDeath: UILabel!
    @IBOutlet weak var labelSex: UILabel!
    @IBOutlet weak var labelNoOfRelations: UILabel!
    @IBOutlet var labelInfoCollection: [UILabel]!
    
    //MARK: - Data

    let kAddRootPersonSegueIdentifer = "AddRootPersonSegue"
    
    //MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let savedSSN = DataManager.shared.lastLoadedSSN {    //If any last saved SSN found, load it.
            loadData(with: savedSSN)
        }
        else {      //Or else, show user options to proceed.
            showLoginOptions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBOutlets Actions
    
    @IBAction func clearAction(_ sender: Any) {
        
        let message = "Are you sure you want to clear existing root person from app?"
        
        let alertController = UIAlertController(title: "Alert !!", message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.cleanUpContent()
        })
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
        
    //MARK: - Internal Methods
    
    internal func loadData(with ssnId: NSNumber) {
        let networkManager = NetworkManager.shared
        networkManager.delegate = self
        networkManager.loadPersonInfo(with: ssnId)
    }
    
    internal func updateUI(with person: Person?) {
        labelSSN.text = person?.ssn.stringValue ?? kNotAvailable
        labelName.text = person?.name ?? kNotAvailable
        labelDateOfBirth.text = person?.dateBirth ?? kNotAvailable
        labelDateOfDeath.text = person?.dateDeath ?? kNotAvailable
        labelSex.text = person?.sex.stringValue ?? kNotAvailable
        labelNoOfRelations.text = person != nil ? String(person!.relationships.count) : kNotAvailable
    }
    
    internal func cleanUpContent() {
        
        let dataManager = DataManager.shared
        dataManager.rootPerson = nil
        
        updateUI(with: nil)
        showLoginOptions()
        ((tabBarController?.viewControllers?.last as? UINavigationController)?.viewControllers.first as? GraphVC)?.refreshContent = true
    }

    //MARK: - Private Methods

    private func showLoginOptions() {
        
        let title = "Please select to continue !!"
        let message = "Are you a registered family member ?"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let newUserAction = UIAlertAction(title: "No (New member)", style: .default, handler: { action in
            self.loadRegistrationView()
        })
        alertController.addAction(newUserAction)

        let existingUserAction = UIAlertAction(title: "Yes (Existing member)", style: .default, handler: { action in
            self.showExistingUserAlert()
        })
        alertController.addAction(existingUserAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func loadRegistrationView() {
        performSegue(withIdentifier: kAddRootPersonSegueIdentifer, sender: nil)
    }
    
    private func showExistingUserAlert() {
        
        let title = "Please enter your SSN !!"
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: { alert in
            if let textField = alertController.textFields?.first,
                let ssnText = textField.text,
                let ssnInt = Int(ssnText) {
                self.loadData(with: NSNumber(value: ssnInt))
            }
        })
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert in
            self.showLoginOptions()
        })
        
        alertController.addTextField { textField -> Void in
            textField.placeholder = "Enter SSN here..."
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .numberPad
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kAddRootPersonSegueIdentifer,
            let navController = segue.destination as? UINavigationController,
            let toPresentVC = navController.viewControllers.first as? AddConnectionVC {
            
            toPresentVC.delegate = self
            toPresentVC.inputMode = .addingRoot
        }
    }
    
    //MARK: - AddConnectionDelegate
    
    func dataDidUpdated(updated: Bool) {
        if updated {
            if let savedSSN = DataManager.shared.lastLoadedSSN {
                loadData(with: savedSSN)
            }
        }
        else {
            showLoginOptions()
        }
    }

    //MARK: - NetworkDelegate - Receiving Info
    
    func willReceivePersonInfo(with ssnId: NSNumber) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func didReceivePersonInfo(with ssnId: NSNumber, person: Person) {
        MBProgressHUD.hide(for: view, animated: true)
        
        //Person received, lets save it
        let dataManager = DataManager.shared
        dataManager.rootPerson = person
        
        //lets update UI
        updateUI(with: person)
    }
    
    func didReceiveErrorWhileReceiveingPersonInfo(with ssnId: NSNumber, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)
        
        if error != nil {
            var message: String = error!.localizedDescription
            
            if let error = error as? CustomError {
                message = error.localizedDescription
            }
            
            Message.showErrorMessage(text: message)
        }
        
        showLoginOptions()
    }
}

