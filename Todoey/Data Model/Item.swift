//
//  Item.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/30/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//
import RealmSwift
import Foundation

class Item: Object
{
@objc dynamic var title : String = ""
@objc dynamic var done : Bool = false
@objc dynamic var dateCreated : Date?
    
var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}