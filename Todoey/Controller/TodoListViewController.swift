//
//  ViewController.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/16/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       

    
        
        let newItem = Item()
        newItem.title = "find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        
        let newItem3 = Item()
        newItem3.title = "Destory Demogoron"
        itemArray.append(newItem3)
        
        loadItems()

    }

    //MARK - table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType  = itemArray[indexPath.row].done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks the Add Item button on our UIAlert
            print("Success")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK  - Model Manipulation Methods
    
    func saveItems()
    {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding array, \(error)")
        }
         self.tableView.reloadData()
        
    }
    
    func loadItems()
    {
        
       
        if  let data = try? Data(contentsOf: dataFilePath!){
             let decoder = PropertyListDecoder()
            do{
              itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
              print("Error while decoding\(error)")
            }
        }
        
        
    }
}


