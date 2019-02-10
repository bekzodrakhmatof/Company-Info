//
//  CreateCompanyController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 10/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllerView()
        setupNavigationItem()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    fileprivate func setupControllerView() {
        view.backgroundColor = .darkBlue
    }
    
    @objc fileprivate func handleCancel() {
        
        dismiss(animated: true)
    }
}
