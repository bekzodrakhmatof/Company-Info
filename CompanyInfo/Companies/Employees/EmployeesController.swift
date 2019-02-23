//
//  EmployeesController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 12/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func draw(_ rect: CGRect) {
        
        let customRect = self.bounds.inset(by: .init(top: 0, left: 16, bottom: 0, right: 0))
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    var allEmployees = [[Employee]]()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
    fileprivate func fetchEmployees() {
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter{ $0.type == employeeType}
            )
        }
    }
    
    @objc fileprivate func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navigationController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .headerColor
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction   = UITableViewRowAction(style: .normal,      title: "Edit",   handler: editHandlerFunction)
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        
        editAction.backgroundColor   = .darkBlue
        deleteAction.backgroundColor = .barTintColor
        
        return [deleteAction, editAction]
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        if indexPath.section == 0 {
            
        }
        let emplyee = allEmployees[indexPath.section][indexPath.row]
        cell.textLabel?.text = emplyee.name
        
        if let birthday = emplyee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(emplyee.name ?? "")    \(dateFormatter.string(from: birthday))"
        }

        cell.backgroundColor = UIColor.lightBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {

        guard let section = employeeTypes.index(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}
