//
//  EmployeesController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 12/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    
    var company: Company?
    var employees = [Employee]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    fileprivate func fetchEmployees() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employees = try context.fetch(request)
            self.employees = employees
            tableView.reloadData()
        } catch let error {
            print("Failed to fetch employees: \(error)")
        }
    }
    
    @objc fileprivate func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let emplyee = employees[indexPath.row]
        cell.textLabel?.text = emplyee.name
        
        if let taxId = emplyee.employeeInformation?.taxId {
            cell.textLabel?.text = "\(emplyee.name ?? "")    \(taxId)"
        }
        cell.backgroundColor = UIColor.lightBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
}
