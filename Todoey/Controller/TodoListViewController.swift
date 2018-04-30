//
//  ViewController.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/16/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        self.saveItems()
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
            
            
            let newItem = Item(context: self.context)
        
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do {
            try context.save()
        }
        catch{
            
            print("Error while Saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil)
    {
            let categoryPredicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if request.predicate == nil{
//             let predicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//            request.predicate = predicate
//        }
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        
        do
        {
            itemArray = try context.fetch(request)
            
        }
        catch
        {
            print("Error fetching data from the context \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    
  
}

//MARK:- Search bar methods

extension TodoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: request.predicate )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }

    }
}
