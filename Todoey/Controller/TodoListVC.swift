//
//  ViewController.swift
//  Todoey
//
//  Created by Daniel Nimafa on 11/09/18.
//  Copyright © 2018 Kipacraft. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    let defaults = UserDefaults.standard
    
    
    let ARRAY_TAG = "TodoListData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
         loadItems()
        
    }
    
    // MARK:- TableView Configuration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        print("numberOfRowsInSection: \(item.done)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(itemArray[indexPath.row ])")
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        saveItems()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        
        print("Select Action: \(item.done)")
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        //        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK:- CRUD Operations
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            print("New Item : \(textField.text!)")
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
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
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching from context. Issue: \(error)")
        }
    }
    
}












