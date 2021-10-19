
import Foundation



func print(_ planning: Planning) {
    
    print("==== Planning ====")
    print()
    
    for item in planning.items {
        
        print("* \(item.id)")
        print("  \(item.startDate) - \(item.task.id)")
        print("                              \(item.task.name)")
        print("  \(item.endDate)")
        print()
    }
}
