//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/29/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       loadCategory()
    
    }
    
     //Mark: TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
    
        
        return cell
    }
     //Mark: DataManipulation Methods
    
    func save(category: Category)
    {
        
        do {
            try realm.write {
                realm.add(category)
                }
        }
        catch{
            
            print("Error while Saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory()
    {
        
        categoryArray = realm.objects(Category.self)
       self.tableView.reloadData()

    }

    
    
    
    //Mark: Add New Categories
   
  
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            //what will happen when user clicks the Add Item button on our UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Mark: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
       if  let indexPath =   tableView.indexPathForSelectedRow
       {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
        
    }
}

