
import Foundation



func print(_ backlog: Backlog) {
    
    print("==== Backlog ====")
    print()
    
    for task in backlog.tasks {
        
        print("* \(task.id)")
        print("  \(task.name)")
        print()
    }
}


func print(_ planning: Planning) {
    
    print("==== Planning ====")
    print()
    
    for entry in planning.entries {
        
        print("* \(entry.id)")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.startDate, dateStyle: .short, timeStyle: .short)) - \(entry.task.id)")
        print("                     \(entry.task.name)")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.endDate, dateStyle: .short, timeStyle: .short))")
        print()
    }
}
