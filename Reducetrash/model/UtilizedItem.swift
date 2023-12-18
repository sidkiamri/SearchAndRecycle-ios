//
//  UtilizedItem.swift
//  Reducetrash
//
//  Created by taha majdoub on 7/4/2023.
//

import Foundation
import RealmSwift

final class UtilizedItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var image: String = ""
    @Persisted var number: Int = 0
    @Persisted var createdDate = Date()
    
    override class func primaryKey() -> String? {
        "id"
    }
}
