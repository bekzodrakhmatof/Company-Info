//
//  EmployeesController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 12/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    @objc fileprivate func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        let navigationController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navigationController, animated: true, completion: nil)
    }
}
