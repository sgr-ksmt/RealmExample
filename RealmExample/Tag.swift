//
//  Tag.swift
//  RealmExample
//
//  Created by Suguru Kishimoto on 9/29/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import RealmSwift

final class Tag: Object {
    dynamic var id = 0
    dynamic var name = ""
    let blogs = List<Blog>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
