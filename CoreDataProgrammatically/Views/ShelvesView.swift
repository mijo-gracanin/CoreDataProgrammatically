//
//  ShelvesView.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 17.11.2022..
//

import SwiftUI
import CoreData

struct ShelvesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.number, order: .forward)],
        animation: .default)
    private var shelfs: FetchedResults<Shelf>

    var body: some View {
        NavigationView {
            List {
                ForEach(shelfs) { shelf in
                    NavigationLink {
                        BooksView(shelf: shelf)
                    } label: {
                        Text(shelf.number.description)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Shelfs")
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
        }
    }

    private func addItem() {
        withAnimation {
            let shelf = Shelf(context: viewContext)
            shelf.number = Int64.random(in: 0...9999)

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
            offsets.map { shelfs[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ShelvesView_Previews: PreviewProvider {
    static var previews: some View {
        ShelvesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
