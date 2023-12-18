//
//  NSManagedObjectModel.swift
//  Reducetrash
//
//  Created by taha majdoub on 6/4/2023.
//

import CoreData

extension NSManagedObjectModel {
    static func model() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let userEntity = NSEntityDescription()
        userEntity.name = "User"
        userEntity.managedObjectClassName = "User"

        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .stringAttributeType
        idAttribute.isOptional = true
        userEntity.properties.append(idAttribute)

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = true
        userEntity.properties.append(nameAttribute)

        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.attributeType = .stringAttributeType
        emailAttribute.isOptional = true
        userEntity.properties.append(emailAttribute)

        let phoneAttribute = NSAttributeDescription()
        phoneAttribute.name = "phone"
        phoneAttribute.attributeType = .stringAttributeType
        phoneAttribute.isOptional = true
        userEntity.properties.append(phoneAttribute)

        let birthdateAttribute = NSAttributeDescription()
        birthdateAttribute.name = "birthdate"
        birthdateAttribute.attributeType = .stringAttributeType
        birthdateAttribute.isOptional = true
        userEntity.properties.append(birthdateAttribute)

        let passwordAttribute = NSAttributeDescription()
        passwordAttribute.name = "password"
        passwordAttribute.attributeType = .stringAttributeType
        passwordAttribute.isOptional = true
        userEntity.properties.append(passwordAttribute)

        model.entities = [userEntity]
        return model
    }
}
