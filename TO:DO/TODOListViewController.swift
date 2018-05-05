//
//  ViewController.swift
//  TO:DO
//
//  Created by Jack Owens on 1/5/18.
//  Copyright © 2018 Jack Owens. All rights reserved.
//

import UIKit

class TODOListViewController: UITableViewController {
    
    
    
    var itemArray = ["Find Mike", "Buy Eggos", "Defeat Demigorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new TO:DO item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)  { (action) in
            
            if textField.text == "" {
                print("No text")
            } else {
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
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
    


}

