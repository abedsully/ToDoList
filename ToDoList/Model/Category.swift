//
//  Category.swift
//  ToDoList
//
//  Created by Stefanus Albert Wilson on 9/25/23.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    // List to make relationship between entity
    let items = List<Item>()
}


