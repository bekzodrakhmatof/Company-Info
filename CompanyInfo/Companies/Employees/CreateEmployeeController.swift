//
//  CreateEmployeeController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 12/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    var delegate: CreateEmployeeControllerDelegate?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Create Employee"
        setupCancelButton()
        
        view.backgroundColor = .darkBlue
        _ = setupLightBackgroundView(height: 50)
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
    }
    
    @objc fileprivate func handleSaveButton() {
        
        guard let name = nameTextField.text else { return }
        guard let company = company else { return }
            
        let tuple = CoreDataManager.shared.createEmployee(employeeName: name, company: company)
        
        if let error = tuple.1 {
            print("Error has been occured: \(error)")
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive  = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive                  = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive                  = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive    = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive        = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive       = true
    }
}
