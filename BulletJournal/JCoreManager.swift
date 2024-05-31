//
//  JCoreManager.swift
//  bullet-journal
//
//  Created by null on 5/30/24.
//

import Foundation
import CoreData

// Simple date format for use with entries
// Made to exclude time
struct SimpleDate{
    var day : Int16
    var month : Int16
    var year : Int32
}

// Converts date to simple date for use in core data
func date2simple(_ date : Date) -> SimpleDate{
    SimpleDate(day: Int16(date.formatted(Date.FormatStyle().day(.twoDigits)))!,
               month: Int16(date.formatted(Date.FormatStyle().month(.twoDigits)))!,
               year: Int32(date.formatted(Date.FormatStyle().year(.defaultDigits)))!
    )
}

// CoreData Manager Singleton
class JCoreManager: ObservableObject{
    // Initialize datastack
    static let jStack = JCoreManager()
    
    //
    lazy var presistContainer : NSPersistentContainer = {
        // Give data file name
        let container = NSPersistentContainer(name: "BulletJournal")
        
        container.loadPersistentStores{ _, error in
            if let error{
                fatalError("Core Data Initialization Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // Save uncommited data
    func save(){
        // Exit if nothing to save
        guard presistContainer.viewContext.hasChanges else {return}
        
        do{
            // Save changes
            try presistContainer.viewContext.save()
        } catch {
            // Print error if error on save
            print("Error on data save : \(error.localizedDescription)")
        }
    }
    
    // Creates a new extry and returns reference to that entry
    func createEntry(_ date: Date) -> JournalEntry{
        // Format date
        let sDate: SimpleDate = date2simple(date)
        // Create and populate new entry with date data
        let newEntry = JournalEntry(context: presistContainer.viewContext)
        newEntry.day = sDate.day
        newEntry.month = sDate.month
        newEntry.year = sDate.year
        save()
        return newEntry
    }
    
    // Get an entry given a date
    func getEntry(_ date: Date) -> JournalEntry? {
        let sDate: SimpleDate = date2simple(date)
        
        let request : NSFetchRequest = JournalEntry.fetchRequest()
        request.fetchLimit = 1
        // Filter by matching date
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "day == \(sDate.day)"),
            NSPredicate(format: "month == \(sDate.month)"),
            NSPredicate(format: "year == \(sDate.year)")
        ])
        
        // Attempt request or return nil
        do {
            let entry = try presistContainer.viewContext.fetch(request).first
            return entry
        } catch {
            print("Fetch Entry Error : \(error.localizedDescription)")
            return nil
        }
    }
    
    func getEntries() -> [JournalEntry] {
        let request : NSFetchRequest = JournalEntry.fetchRequest()
        do {
            let entries = try presistContainer.viewContext.fetch(request)
            return entries
        } catch {
            print("Error getting enties")
            return []
        }
    }
    
    // Delete Entry from datastack
    // TODO Delete childern
    func delete(item: JournalEntry){
        presistContainer.viewContext.delete(item)
        save()
    }
    
    // Bored with r
    func createElement(_ parent: JournalEntry,_ text: String){
        let newElement = JournalElement(context: presistContainer.viewContext)
        newElement.text = text
        
        // This causes crash and I couldn't for the life of my get relationships working
        // Caused by context error I cant for the life of me trace down
        // Theoritically if this is working my code is basically done ;-;
        // newElement.entry = parent
        save()
    }
    
    // Gets all elements for a given entry
    // Untestest due to Above issue
    func getElements(_ parent: JournalEntry) -> [JournalElement]{
        // Create Request
        let request: NSFetchRequest = JournalElement.fetchRequest()
        // Mathc by existsing in parent's element relationship
        request.predicate = NSPredicate(format:"SELF IN \(String(describing: parent.elements))")
        
        do{
            // Get Elements
            let elements = try presistContainer.viewContext.fetch(request)
            return elements
        } catch {
            // Error return empty list
            print("Error when getting elements : \(error.localizedDescription)")
            return []
        }
    }
    
    // Deletes Single Element from datastack
    func delete(item: JournalElement){
        presistContainer.viewContext.delete(item)
        save()
    }
}
