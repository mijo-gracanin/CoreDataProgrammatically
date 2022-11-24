//
//  Persistence.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 17.11.2022..
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Shelf(context: viewContext)
            newItem.number = Int64.random(in: 0...9999)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        let managedObjectModel = PersistenceController.createManagedObjectModel()
        
        container = NSPersistentContainer(name: "CoreDataProgrammatically", managedObjectModel: managedObjectModel)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let managedObjectModel = NSManagedObjectModel()
        
        // Shelf entity
        let shelfEntityDescription = NSEntityDescription()
        shelfEntityDescription.name = String(describing: Shelf.self)
        shelfEntityDescription.managedObjectClassName = String(describing: Shelf.self)
        
        let numberDescription = NSAttributeDescription()
        numberDescription.name = "number"
        numberDescription.attributeType = .integer64AttributeType
        
        let booksRelationshipDescription = NSRelationshipDescription()
        booksRelationshipDescription.name = "books"
        
        booksRelationshipDescription.maxCount = 0
        booksRelationshipDescription.deleteRule = .cascadeDeleteRule
        
        shelfEntityDescription.properties = [numberDescription, booksRelationshipDescription]
        
        // Book entity
        let bookEntityDescription = NSEntityDescription()
        bookEntityDescription.name = String(describing: Book.self)
        bookEntityDescription.managedObjectClassName = String(describing: Book.self)
        
        let nameDescription = NSAttributeDescription()
        nameDescription.name = "name"
        nameDescription.attributeType = .stringAttributeType
        
        let shelfRelationshipDescription = NSRelationshipDescription()
        shelfRelationshipDescription.name = "shelf"
        shelfRelationshipDescription.destinationEntity = shelfEntityDescription
        shelfRelationshipDescription.maxCount = 1
        shelfRelationshipDescription.deleteRule = .nullifyDeleteRule
        shelfRelationshipDescription.inverseRelationship = booksRelationshipDescription
        
        bookEntityDescription.properties = [nameDescription, shelfRelationshipDescription]
        
        booksRelationshipDescription.destinationEntity = bookEntityDescription
        booksRelationshipDescription.inverseRelationship = shelfRelationshipDescription
        
        managedObjectModel.entities = [shelfEntityDescription, bookEntityDescription]
        
        return managedObjectModel
    }
}
