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
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            self.companies = try context.fetch(fetchRequest)
            self.tableView.reloadData()
           
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
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
//            companies.forEach { (company) in
//                companies.index
//            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .top)
//            companies.removeAll()
//            tableView.reloadData()
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
    
    // MARK: - Table View Delegate and Datasource
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .headerColor
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let foundedDateString = dateFormatter.string(from: founded)
        
            cell.textLabel?.text = "\(name) - Founded: \(foundedDateString)"
        } else {
            cell.textLabel?.text = company.name
        }
        
        cell.backgroundColor = .lightBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        if let imageData = company.imageData {
            let companyImage = UIImage(data: imageData)
            cell.imageView?.image = companyImage
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction   = UITableViewRowAction(style: .normal,      title: "Edit",   handler: editHandlerFunction)
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        
        editAction.backgroundColor   = .darkBlue
        deleteAction.backgroundColor = .barTintColor
        
        return [deleteAction, editAction]
    }
    
    fileprivate func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
        do {
            try context.save()
        } catch let error {
            print("Failed to delete company: \(error)")
        }
    }
    
    fileprivate func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: editCompanyController)
        present(navigationController, animated: true)
    }
}

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didAddComapany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditComapany(company: Company) {
        
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
}
