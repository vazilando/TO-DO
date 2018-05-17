//
//  ViewController.swift
//  TO:DO
//
//  Created by Jack Owens on 1/5/18.
//  Copyright © 2018 Jack Owens. All rights reserved.
//

import UIKit
import CoreData

class TODOListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var parentCategory : Category? {
        didSet{
            navigationItem.title = parentCategory!.name!
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //print("File path is ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //DELETE method
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new TO:DO item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)  { (action) in
            
            if textField.text == "" {
                print("No text")
            } else {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.parentCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context- \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), searchPredicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        
        if let additionalPredicate = searchPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        


        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Context - \(error)")
        }
        
        tableView.reloadData()
    }
    

}



//MARK: - Search bar methods

extension TODOListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
            
            
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, searchPredicate: searchPredicate)
        }

        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    

    

    

}

