//
//  EntryView.swift
//  bullet-journal
//
//  Created by null on 5/2/24.
//

import SwiftUI


//=== Main view
struct EntryView: View{
    // Local Variables
    // Entry Date
    var entryDate: Date
    // Core data stack
    @Environment(\.managedObjectContext) private var viewContext
    
    // Get Jounral Entry if it exsists
    @State
    var jEntry: JournalEntry
    
    // State of add dialog
    @State
    var addDialog : Bool = false
    // If entrys can be added (Only on current day)
    var editMode : Bool
    // Journal Strings to Display
    @State
    var journal : [String] = []
    // Binding for String input
    @State
    var inputText : String = ""
    
    // Init (stores provided date)
    init(providedDate: Date, mode: Bool = false){
        entryDate = providedDate
        editMode = mode
        jEntry = JCoreManager().getEntry(entryDate) ?? JCoreManager().createEntry(entryDate)
    }
    
    // Main view for entry
    var body: some View{
        ZStack{
            // Main View
            VStack(alignment: .leading){
                // Top bar
                HStack{
                    // Title
                    
                    Text(entryDate.formatted(date: .long, time: .omitted))
                        .font(.largeTitle)
                        .fontWeight(.ultraLight)
                }
                .padding(.horizontal)
                
                // End of Header
                // Divider()
                
                
                
                // Entry Body
                // This would display all the elements if I could get relationships working
                // See JCoreManager.createElement()
                List{
                    // ForEach(jEntry.elements?.sorted, id:\.self){
                        // entry in
                        //Text(entry.text ?? "error")
                    //}
                }
                
                Spacer()
            }
            
            // Add Entry Button
            if editMode{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        
                        // Edit/Save button
                        Button(action: {
                            addDialog.toggle()
                        }){
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 40, height:40)
                        }
                        .alert("Entry Text:", isPresented: $addDialog){
                            TextField("", text: $inputText, axis: .vertical)
                            Button("Add", role:.destructive, action:{
                                // Add item
                                // Element Creation
                                JCoreManager().createElement(jEntry, inputText)
                                
                                // Clear Text
                                inputText=""
                            })
                        }
                        .padding([.bottom, .trailing], 20.0)
                    }
                }
            }
        }
    }
}

//=== Helper functions


// Preview config
#Preview {
    EntryView(providedDate: Date(), mode: true)
}
