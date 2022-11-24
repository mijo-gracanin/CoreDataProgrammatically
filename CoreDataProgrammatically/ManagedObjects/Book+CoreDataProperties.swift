//
//  Book+CoreDataProperties.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 22.11.2022..
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var name: String?
    @NSManaged public var shelf: Shelf?

}

extension Book : Identifiable {

}
