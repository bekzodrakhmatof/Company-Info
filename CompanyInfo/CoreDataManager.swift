//
//  CoreDataManager.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 10/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ComapnyInfo")
        container.loadPersistentStores { (store, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
            
        } catch let error {
            print("Failed to fetch date from Core Data: \(error)")
            return []
        }
    }
    
    func createEmployee(employeeName: String) -> (Employee?, Error?) {
        
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.name = employeeName
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInformation.taxId = "456"
    
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil)
        } catch let error {
            print("Failed to create employee: \(error)")
            return (nil, error)
        }
    }
}
