//
//  ContentView.swift
//  Bookworm
//
//  Created by Soumyattam Dey on 29/07/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext)  var viewContext

    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true),NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List{
                ForEach(books,id: \.self){ book in
                    NavigationLink(
                        destination: DetailView(book: book),
                        label: {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading){
                                Text(book.title ?? "Unknown Title")
                                Text(book.author ?? "Unknown Author")
                            }
                        })
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.viewContext)
            }
           
       }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
    func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for offset in offsets{
                let book=books[offset]
                viewContext.delete(book)
            }
            try? viewContext.save()
        }
    }
    
    
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
