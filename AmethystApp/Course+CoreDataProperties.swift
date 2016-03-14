//
//  Course+CoreDataProperties.swift
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

extension Course {

    @NSManaged var link: String?
    @NSManaged var title: String?
    @NSManaged var topic: String?
    @NSManaged var user: User?

}
