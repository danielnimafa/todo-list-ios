//
//  ViewController.swift
//  Todoey
//
//  Created by Daniel Nimafa on 11/09/18.
//  Copyright © 2018 Kipacraft. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UITableViewController {
    
    var itemResults: Results<Item>?
    var selectedCategory: Kategory? {
        didSet {
            navigationItem.title = selectedCategory?.name ?? "-"
            loadItems()
        }
    }
    let realm = try! Realm()
    
    //    let defaults = UserDefaults.standard
    
    
    let ARRAY_TAG = "TodoListData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- TableView Configuration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = itemResults?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No data"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemResults?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item) // removing item in realm
                    item.done = !item.done
                }
            } catch let err {
                print("Failed updating data: \(err.localizedDescription)")
            }
        }
        
        tableView.reloadData()
        
//        print("selected \(itemArray[indexPath.row ])")
//
//        let item = itemArray[indexPath.row]
//        item.done = !item.done
//
//        saveItems()
//
//        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
//
//        print("Select Action: \(item.done)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK:- CRUD Operations
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            print("New Item : \(textField.text!)")
            
            if textField.text! != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch let err {
                        print("Failed to save: \(err.localizedDescription)")
                    }
                }
                
                self.tableView.reloadData()
            }
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    private func populateData() {
        
        //        let item1 = Item("Find my mac", false)
        //        let item2 = Item("Build something i care about", false)
        //        let item3 = Item("Mastering iOS Development", false)
        //
        //        itemArray.append(item1)
        //        itemArray.append(item2)
        //        itemArray.append(item3)
        //
        //        for number in 0...20 {
        //            itemArray.append(Item("\(number)", false))
        //        }
        
    }
    
    func loadItems() {
        
        itemResults = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        
    }
    
}

// MARK: - Search Bar Methods
extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
