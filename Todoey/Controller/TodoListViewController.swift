//
//  ViewController.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/16/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    var todoItems  : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
           loadItems()
        }
    }
    
    
    
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

    //MARK - table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No Items Added"
          
        }
        return cell
    }
    
    //MARK - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
         var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks the Add Item button on our UIAlert
            print("Success")
            
            if let currentCategory = self.selectedCategory
            {
                do {
                    try
                        self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                    }
                }
                catch{
                    
                    print("Error while Saving \(error)")
                }
                
                self.tableView.reloadData()
                
            }
            
    
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK  - Model Manipulation Methods
    
//    func saveItems()
//    {
//        
//        do {
//            try context.save()
//        }
//        catch{
//            
//            print("Error while Saving \(error)")
//        }
//        self.tableView.reloadData()
//    }
//    
    func loadItems()
    {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        self.tableView.reloadData()

    }

    override func updateModel(at indexPath: IndexPath)
    {
        if let item = self.todoItems?[indexPath.row] {
            try! self.realm.write {
                self.realm.delete(item)
            }
        }
    }
  
}

extension TodoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
         todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
