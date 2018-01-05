//
//  ViewController.swift
//  CoreData
//
//  Created by Kilian on 04.01.18.
//  Copyright © 2018 Kilian. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        let tesla = company
        companies.append(tesla)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)

    }
    
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCompanies()
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
    

        tableView.backgroundColor = .darkblue
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.separatorColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        
        
    }
    
    private func fetchCompanies() {

        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
        
            self.companies = companies
            self.tableView.reloadData()
        }catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr )
        }
       
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.backgroundColor = .tealColor
    
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }

}

