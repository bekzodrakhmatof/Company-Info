//
//  CompaniesAutoUpdateController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 17/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchResutsController: NSFetchedResultsController<Company> = {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Company Auto Updates"
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        fetchResutsController.fetchedObjects?.forEach({ (company) in
            print(company.name ?? "")
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl
    
    }
    
    @objc fileprivate func handleRefresh() {
        
        Service.shared.donwloadCompaniesFromServer()
        self.refreshControl?.endRefreshing()
    }
    
    @objc fileprivate func handleDelete() {
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
//        request.predicate = NSPredicate(format: "name CONTAINS %@", "Z")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let companiesWwithB = try context.fetch(request)
            companiesWwithB.forEach { (company) in
                context.delete(company)
            }
            
            do {
                try context.save()
            } catch let error {
                print("Failed to save company: \(error)")
            }
        } catch let error {
            print("Failed to fetch companies with B: \(error)")
        }
        
    }
    
    @objc fileprivate func handleAdd() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "ZMW"
        
        do {
            try context.save()
        } catch let error {
            print("Failed to add: \(error)")
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchResutsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
        label.text = fetchResutsController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.headerColor
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchResutsController.sections?.count ?? 0
    }
    
    let cellID = "CellID"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
        let company = fetchResutsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesListController = EmployeesController()
        employeesListController.company = fetchResutsController.object(at: indexPath)
        navigationController?.pushViewController(employeesListController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
}
