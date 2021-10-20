
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
    
    var latestReferenceDate: Date? = nil
    
    if let timeSlot = timeSlot {
        latestReferenceDate = timeSlot.startDate
    }
    
    for entry in dataModel.planningEntries(in: timeSlot) {
        
        if let latestReferenceDate = latestReferenceDate,
           entry.timeSlot.startDate > latestReferenceDate {
            
            printEmptyEntry(on: TimeSlot(between: latestReferenceDate, and: entry.timeSlot.startDate))
        }
        
        print("* \(entry.id)")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.startDate, dateStyle: .short, timeStyle: .short)) - \(entry.task.id)")
        print("                     \(entry.task.name)")
        print("                     Feedback: \(entry.feedback?.description ?? "-")")
        print("  \(DateFormatter.localizedString(from: entry.timeSlot.endDate, dateStyle: .short, timeStyle: .short))")
        print()
        
        latestReferenceDate = entry.timeSlot.endDate
    }
    
    if let timeSlot = timeSlot,
       let latestReferenceDate = latestReferenceDate,
       latestReferenceDate < timeSlot.endDate {
    
        printEmptyEntry(on: TimeSlot(between: latestReferenceDate, and: timeSlot.endDate))
    }
}


func printEmptyEntry(on timeSlot: TimeSlot) {
    
    print("* (Empty)")
    print("  \(DateFormatter.localizedString(from: timeSlot.startDate, dateStyle: .short, timeStyle: .short)) - Empty")
    print("  \(DateFormatter.localizedString(from: timeSlot.endDate, dateStyle: .short, timeStyle: .short))")
    print()
}
