//
//  CalendarView.swift
//  bullet-journal
//
//  Created by null on 5/30/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext

    func simple2date(_ day: Int16,_ month: Int16,_ year: Int32)-> Date{
        let parser = DateFormatter()
        var monthHotFix : String = ""
        if month < 10{
            monthHotFix = "0"
        }
        parser.dateFormat = "dd/MM/yyyy"
        let result : String = "\(String(day))/\(monthHotFix)\(String(month))/\(String(year))"
        return parser.date(from: result)!
    }

    
    var body: some View {
        NavigationStack{
            List{
                ForEach(JCoreManager().getEntries(), id: \.self){
                    entry in
                    NavigationLink{
                        EntryView(providedDate: simple2date(entry.day, entry.month, entry.year), mode:false)
                    } label: {
                        Text("\(String(entry.day))/\(String(entry.month))/\(String(entry.year))")
                        Text(simple2date(entry.day, entry.month, entry.year).formatted(date: .long, time: .omitted))
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
