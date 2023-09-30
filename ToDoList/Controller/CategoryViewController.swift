//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Stefanus Albert Wilson on 9/24/23.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        


    }
    
    // MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if .count is not nil then it returns, if it's nil then return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: Constant.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    

    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: Constant.alertTitleCategory, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constant.alertActionCategory, style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = Constant.alertTextFieldCategoryPlaceHolder
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Manipulation Methods
    
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch{
                print("Error deleting items \(error)")
            }
            
        }
    }
    
}
