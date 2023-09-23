//
//  ViewController.swift
//  ToDoList
//
//  Created by Stefanus Albert Wilson on 9/18/23.
//

import UIKit
import CoreData

class ToDoListController: UITableViewController {
    
    var itemArray = [Item]()

    // accessing viewContext from App Delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
    }
    
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItems()
    
    }
    
    // MARK: - Add New Items
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // message here is the text under the title
        let alert = UIAlertController(title: Constant.alertTitle, message: "", preferredStyle: .alert)
        
        
        //handle closure
        let action = UIAlertAction(title: Constant.alertActionTitle, style: .default) { (action) in
            

            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = Constant.alertTextFieldPlaceHolder
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()

    }
    
//    func loadItems(){
//
//        do{
//            if let data = try? Data(contentsOf: dataFilePath!){
//                let decoder = PropertyListDecoder()
//
//                do{
//                    itemArray = try decoder.decode([Item].self, from: data)
//                } catch{
//                    print("Error decoding item array, \(error)")
//                }
//
//            }
//
//        }
//
//    }
    
}

