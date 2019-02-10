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
        fetchCompanies()
    }
    
    fileprivate func fetchCompanies() {
        
        let persistentContainer = NSPersistentContainer(name: "ComapnyInfo")
        persistentContainer.loadPersistentStores { (store, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            companies = try context.fetch(fetchRequest)
           
        } catch let error {
            print("Failed to fetch date from Core Data: \(error)")
        }
    }
    
    fileprivate func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
    }
    
    fileprivate func setupControllerView() {
        view.backgroundColor = .darkBlue
    }
    
    @objc fileprivate func handleAdd() {
        
//        addComapny()
    }
    
    @objc fileprivate func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .headerColor
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.backgroundColor = .lightBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didAddComapany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
}
