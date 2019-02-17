//
//  Service.swift
//  CompanyInfo
//
//  Created by Bekzod Rakhmatov on 17/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func donwloadCompaniesFromServer() {
        
        print("Attempting to download companies")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            print("Finished downloading")
            
            if let error = error {
                print("Failed to download companies: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                jsonCompanies.forEach({ (jsonCompany) in
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        employee.employeeInformation = employeeInformation
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let error {
                        print("Failed to save company: \(error)")
                    }
                })
            } catch let error {
                print("Failed to decode SJONCompany: \(error)")
            }
            
            
            
        }.resume()
    }
}

struct JSONCompany: Decodable {
    
    let name:    String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    
    let name: String
    let type: String
    let birthday: String
}
