//
//  Category.swift
//  Todoey
//
//  Created by Kunal Mathur on 4/30/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
