//
//  User.swift
//  Reducetrash
//
//  Created by taha majdoub on 6/4/2023.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var id: String?

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var birthdate: String?
    @NSManaged public var password: String?
    
}

