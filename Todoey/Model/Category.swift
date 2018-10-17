//
//  Category.swift
//  Todoey
//
//  Created by Daniel Nimafa on 16/10/18.
//  Copyright © 2018 Kipacraft. All rights reserved.
//

import Foundation
import RealmSwift

class Kategory : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
