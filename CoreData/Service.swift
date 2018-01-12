//
//  Service.swift
//  CoreData_Test
//
//  Created by Kilian on 10.01.18.
//  Copyright © 2018 Kilian. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    func downloadCompaniesFromServer() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print(err)
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
                    dateFormatter.dateFormat = "MM/dd/yyyyy"
                    let foundedDate  = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(jsonEmployee.name)
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
                    }catch let err{
                        print("Failed to save companies: ", err)
                    }
                })
            }catch let decoderErr {
                print("Faild to decode: ", decoderErr)
            }
            
            
            
            
            
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    let employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}





