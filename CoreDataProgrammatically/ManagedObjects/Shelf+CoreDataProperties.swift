//
//  Shelf+CoreDataProperties.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 22.11.2022..
//
//

import Foundation
import CoreData


extension Shelf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shelf> {
        return NSFetchRequest<Shelf>(entityName: "Shelf")
    }

    @NSManaged public var number: Int64
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension Shelf {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

extension Shelf : Identifiable {

}
