
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
    
    for item in planning.items {
        
        print("* \(item.id)")
        print("  \(DateFormatter.localizedString(from: item.startDate, dateStyle: .short, timeStyle: .short)) - \(item.task.id)")
        print("                     \(item.task.name)")
        print("  \(DateFormatter.localizedString(from: item.endDate, dateStyle: .short, timeStyle: .short))")
        print()
    }
}
