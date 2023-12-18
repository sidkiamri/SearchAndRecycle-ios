//
//  localRepository.swift
//  Reducetrash
//
//  Created by taha majdoub on 7/4/2023.
//

import RealmSwift
import Foundation

class LocalRepository {
    static let shared = LocalRepository()
    private init() {}

    var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func addUtilizedItem(item: UtilizedItem) {
        try! realm.write {
            realm.add(item)
        }
    }

    func fetchUtilizedItems() -> Results<UtilizedItem> {
        return realm.objects(UtilizedItem.self)
    }

    func deleteUtilizedItem(item: UtilizedItem) {
        try! realm.write {
            realm.delete(item)
        }
    }
}
