//
//  CategoryViewController.swift
//  TO:DO
//
//  Created by Jack Owens on 9/5/18.
//  Copyright © 2018 Jack Owens. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    

    //Declare Category Array & DB context
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK: - Datasource methods (Enable table to display the categories in cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
//        let category = categoryArray[indexPath.row]
//        cell.textLabel?.text = category.name
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TODOListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.parentCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation methods (Save and load)
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        do {
            try categoryArray = context.fetch(Category.fetchRequest())
        } catch {
            print("Error loading Categories from Core Data")
        }
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Add button pressed and add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new TO:DO Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text == "" {
                print("No text input")
            } else {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
            }
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    


}
