//
//  BooksView.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 21.11.2022..
//

import SwiftUI
import CoreData

struct BooksView: View {
    private let shelf: Shelf
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest private var books: FetchedResults<Book>
    
    init(shelf: Shelf) {
        self.shelf = shelf
        _books = FetchRequest<Book>(
            sortDescriptors: [SortDescriptor(\.name, order: .forward)],
            predicate: NSPredicate.init(format: "shelf == %@", shelf)
        )
    }

    var body: some View {
        List {
            ForEach(books) { book in
                Text(book.name!)
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(shelf.number.description)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .onAppear(perform: {
            books.nsPredicate = NSPredicate.init(format: "shelf == %@", shelf)
        })
    }

    private func addItem() {
        withAnimation {
            let book = Book(context: viewContext)
            let letters = "abcdefghijklmnopqrstuvwxyz"
            book.name = String((0..<Int.random(in: 3...10)).map{ _ in letters.randomElement()! }).capitalized
            book.shelf = shelf

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
