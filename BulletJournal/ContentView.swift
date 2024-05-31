//
//  ContentView.swift
//  bullet-journal
//
//  Created by Jeremy W on 5/2/24.
//

// Base imports
import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        // Top tab view
        TabView{
            EntryView(providedDate: Date(), mode:true).tabItem{
                Label("Todays Entry", systemImage:"book.pages")
            }
            CalendarView().tabItem{
                Label("Past Entries", systemImage:"list.bullet")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
