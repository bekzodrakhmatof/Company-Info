//
//  CompaniesController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 10/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllerView()
        setupNavigationItem()
        setupTableView()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(handleDoWork))
        ]
    }
    
    @objc fileprivate func handleDoWork() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...1200000).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
            } catch {
                print("Failed")
            }
        })
    }
    
    fileprivate func setupControllerView() {
        
        view.backgroundColor = .darkBlue
    }
    
    @objc fileprivate func handleReset() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(item: index, section: 0)
                indexPathToRemove.append(indexPath)
            }

            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .top)

        } catch let error {
            print("Failed to delete objects from Core Data: \(error)")
        }
    }
    
    @objc fileprivate func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        present(navigationController, animated: true, completion: nil)
    }
}
