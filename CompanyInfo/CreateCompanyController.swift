//
//  CreateCompanyController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 10/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

// Delegation
protocol CreateCompanyControllerDelegate {
    
    func didAddComapany(company: Company)
    func didEditComapany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
        }
    }
    
    let lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.headerColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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

        setupControllerView()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    fileprivate func setupNavigationItem() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    fileprivate func setupControllerView() {
        view.backgroundColor = .darkBlue
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive         = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive            = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive                 = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive                  = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive                  = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive    = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive        = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive       = true
    }
    
    @objc fileprivate func handleCancel() {
        
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {

        company == nil ? createCompany() : saveCompanyChanges()
    }
    
    fileprivate func saveCompanyChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company!.name = nameTextField.text
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditComapany(company: self.company!)
            }
        } catch let error {
            print("Error to save date into Core Data: \(error)")
        }
    }
    
    fileprivate func createCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text!, forKey: "name")
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddComapany(company: company as! Company)
            }
        } catch let error {
            print("Error to save date into Core Data: \(error)")
        }
    }
}
