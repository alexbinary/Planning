
import Foundation



func printBacklog(from dataModel: DataModel) {
    
    print("==== Backlog ====")
    print()
    
    for task in dataModel.backlog.tasks {
        
        print("* \(task.id)")
        print("  \(task.name)")
        print()
    }
}


func printPlanning(from dataModel: DataModel, for timeSlot: TimeSlot? = nil) {
    
    print("==== Planning ====")
    print()
    
    for entry in dataModel.planningEntries(in: timeSlot) {
        
        print("* \(entry.id)")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.startDate, dateStyle: .short, timeStyle: .short)) - \(entry.task.id)")
        print("                     \(entry.task.name)")
        print("                     Feedback: \(entry.feedback?.description ?? "-")")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.endDate, dateStyle: .short, timeStyle: .short))")
        print()
    }
}
