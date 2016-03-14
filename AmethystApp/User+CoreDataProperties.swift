//
//  User+CoreDataProperties.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 3/11/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var role: String?
    @NSManaged var course: Course?

}
