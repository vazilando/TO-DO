//
//  Category.swift
//  TO:DO
//
//  Created by Jack Owens on 29/6/18.
//  Copyright © 2018 Jack Owens. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
    let items = List<Item>()
}
