//
//  ViewController.swift
//  Todoey
//
//  Created by Daniel Nimafa on 11/09/18.
//  Copyright © 2018 Kipacraft. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableViewController {
    
    var itemResults: Results<Item>?
    var selectedCategory: Kategory? {
        didSet {
            loadItems()
        }
    }
    let realm = try! Realm()
    
    //    let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let ARRAY_TAG = "TodoListData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name ?? "-"
        guard let hexColor = selectedCategory?.color else { return }
        updateNavBar(withHexCode: hexColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //updateNavBar(withHexCode: "FFFFFF")
    }
    
    // MARK:- Nav bar setup
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let color = UIColor(hexString: colorHexCode) else { return }
        let contrastColor = ContrastColorOf(color, returnFlat: true)
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.") }
        navBar.barTintColor = color
        navBar.tintColor = contrastColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        searchBar.barTintColor = color
    }
    
    // MARK:- TableView Configuration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemResults?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemResults!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.itemResults?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Failed deleting item: \(error)")
            }
        }
        
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
