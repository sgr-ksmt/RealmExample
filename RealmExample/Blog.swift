//
//  Blog.swift
//  RealmExample
//
//  Created by Suguru Kishimoto on 9/29/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import RealmSwift

final class Blog: Object {
    dynamic var id = NSUUID().uuidString
    dynamic var title = ""
    dynamic var content = ""
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    let tags = LinkingObjects(fromType: Tag.self, property: "blogs")
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
