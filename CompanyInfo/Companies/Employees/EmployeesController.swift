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
    var employees = [Employee]()

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
    
    fileprivate func fetchEmployees() {
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 5 && count < 9
            }
            return false
        })
        
        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 9
            }
            return false
        })
        
        allEmployees = [
            shortNameEmployees,
            longNameEmployees,
            reallyLongNameEmployees
        ]
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
        if section == 0 {
            label.text = "Short name"
        } else if section == 1 {
            label.text = "Long name"
        } else {
            label.text = "Really long name"
        }
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees  = [Employee]()
    var reallyLongNameEmployees  = [Employee]()
    var allEmployees = [[Employee]]()
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
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
//        if let taxId = emplyee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(emplyee.name ?? "")    \(taxId)"
//        }
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
