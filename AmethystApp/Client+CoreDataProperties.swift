//
//  Client+CoreDataProperties.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 11/10/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Client {

    @NSManaged var name: String?
    @NSManaged var courses: NSMutableSet?

}
