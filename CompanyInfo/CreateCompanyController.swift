//
//  CreateCompanyController.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 10/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    
    func didAddComapany(company: Company)
    func didEditComapany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            setupCircularImageStyle()
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imgView.contentMode = .scaleAspectFill
        return imgView
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
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
    
    fileprivate func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2;
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998704791, alpha: 1).cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    @objc fileprivate func handleSelectPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func setupNavigationItem() {

        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    fileprivate func setupControllerView() {
        view.backgroundColor = .darkBlue
        
        let lightSetupBackgroundView = setupLightBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive              = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive      = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive               = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive  = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive                  = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive                  = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive    = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive        = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive       = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive                  = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive                        = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive                      = true
        datePicker.bottomAnchor.constraint(equalTo: lightSetupBackgroundView.bottomAnchor).isActive = true
    }
    
    @objc fileprivate func handleSave() {

        company == nil ? createCompany() : saveCompanyChanges()
    }
    
    fileprivate func saveCompanyChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company!.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
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
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
    
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

extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
}
