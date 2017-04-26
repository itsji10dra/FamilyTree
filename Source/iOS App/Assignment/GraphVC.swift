//
//  GraphVC.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import UIKit
import MBProgressHUD

class GraphVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate, AddConnectionDelegate  {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableViewGraph: UITableView!
    
    //MARK: - Data
    
    lazy var personArray = [PersonViewModel]()
    let kCellReusableIdentifer = "GraphCell"
    let kAddRelationSegueIdentifer = "AddRelationSegue"
    var refreshContent = false
    
    //MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        loadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if refreshContent {     //Will be true, if user is cleared from first screen
            loadDataSource()
            refreshContent = false
        }
    }
    
    //MARK: - Internal Methods

    internal func loadDataSource() {
        
        if let personInfo = DataManager.shared.rootPerson {
            personArray.removeAll(keepingCapacity: true)
            let personModelObj = PersonViewModel(with: personInfo, generation: 0, isOpen: false, isRoot: true)
            personArray.append(personModelObj)
            tableViewGraph.reloadData()
        }
    }
    
    internal func cleanUpContent() {
        
        personArray.removeAll(keepingCapacity: false)
        tabBarController?.selectedIndex = 0
        ((tabBarController?.viewControllers?.first as? UINavigationController)?.viewControllers.first as? RootInfoVC)?.cleanUpContent()
    }

    //MARK: - Private Methods

    private func loadDataSourceFromServer() {
        
        if let savedSSN = DataManager.shared.lastLoadedSSN {
            
            let networkManager = NetworkManager.shared
            networkManager.delegate = self
            networkManager.loadPersonInfo(with: savedSSN)
        }
    }

    private func deletePerson(with info: PersonViewModel) {
        
        guard let relationId = info.relationId else {
            return
        }
        
        let networkManager = NetworkManager.shared
        networkManager.delegate = self
        networkManager.deleteRealtion(with: relationId, to: info)
    }

    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReusableIdentifer, for: indexPath) as! GraphCell
        
        let infoObj = personArray[indexPath.row]
        
        let name = infoObj.name ?? kNotAvailable
        let yearOfBirth = infoObj.dateBirth?.components(separatedBy: "-").first ?? kNotAvailable
        let yearOfDeath = infoObj.dateDeath?.components(separatedBy: "-").first ?? kNotAvailable
        
        cell.labelInfo.text = "\(name) (\(yearOfBirth) - \(yearOfDeath))"
        cell.labelRelation.text = infoObj.relationType?.stringValue
        cell.paddingMultiplier = infoObj.generation + 1
        cell.accessoryType = infoObj.hasRelations ? .disclosureIndicator : .none        
        cell.buttonAddRelation.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return indexPath.row == 0 ? "Clear" : "Delete\nRelation"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let isRootPerson = indexPath.row == 0
            
            let infoObj = personArray[indexPath.row]

            let message = isRootPerson ? "Are you sure you want to clear existing root person from app?" : "Are you sure you want to delete " + infoObj.name + " as relation?"
            
            let alertController = UIAlertController(title: "Alert !!", message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: isRootPerson ? "Clear" : "Delete", style: .destructive, handler: { action in
                isRootPerson ? self.cleanUpContent() : self.deletePerson(with: infoObj)
            })
            alertController.addAction(defaultAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoObj = personArray[indexPath.row]

        if !infoObj.hasRelations { return }
        
        if infoObj.isOpened
        {
            infoObj.isOpened = false
            
            //Removing all associated relations
            for index in stride(from: infoObj.relationships.count, to: 0, by: -1) {
                personArray.remove(at: indexPath.row + index)
            }
        }
        else
        {
            infoObj.isOpened = true
            
            //Fetching all associated relations
            let childs = infoObj.getAllRelations(level: infoObj.generation + 1)
            personArray.insert(contentsOf: childs, at: indexPath.row + 1)
        }
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    //MARK: - IBOutlets Action
    
    @IBAction func addRelationAction(_ sender: UIButton) {
        
        let infoObj = personArray[sender.tag]

        performSegue(withIdentifier: kAddRelationSegueIdentifer, sender: infoObj)
    }
    
    @IBAction func editAction(_ sender: Any) {
        
        tableViewGraph.setEditing(!tableViewGraph.isEditing, animated: true)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
        loadDataSourceFromServer()
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kAddRelationSegueIdentifer,
            let navController = segue.destination as? UINavigationController,
            let toPresentVC = navController.viewControllers.first as? AddConnectionVC,
            let info = sender as? PersonViewModel {
            
            toPresentVC.delegate = self
            toPresentVC.mainPerson = info
        }
    }
    
    //MARK: - AddConnectionDelegate
    
    func dataDidUpdated(updated: Bool) {
        if updated {
            //Refresh list
            loadDataSourceFromServer()
        }
    }

    //MARK: - NetworkDelegate - Receiving Info
    
    func willReceivePersonInfo(with ssnId: NSNumber) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func didReceivePersonInfo(with ssnId: NSNumber, person: Person) {
        MBProgressHUD.hide(for: view, animated: true)
        
        //Save in data manager
        let dataManager = DataManager.shared
        dataManager.rootPerson = person
        
        //load & reflect in UI.
        loadDataSource()
    }
    
    func didReceiveErrorWhileReceiveingPersonInfo(with ssnId: NSNumber, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)
    }

    //MARK: - NetworkDelegate - Deleting Relations

    func willStartDeletingRelation(with relationId: NSNumber) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func didDeletedRelation(with relationId: NSNumber) {
        MBProgressHUD.hide(for: view, animated: true)
        
        //Let's refresh list
        loadDataSourceFromServer()
    }
    
    func didReceiveErrorWhileDeletingRelation(with relationId: NSNumber, error: Error?) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
