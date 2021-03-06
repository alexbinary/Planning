
import Foundation



func printBacklog(_ backlog: Backlog) {
    
    print("==== Backlog ====")
    print()
    
    for task in backlog.tasks {
        
        print("* \(task.id)")
        print("  \(task.name)")
        print()
    }
}


func printPlanning(_ planning: Planning, for timeSlot: TimeSlot? = nil) {
    
    print("==== Planning ====")
    print()
    
    let printer = Printer()
    
    for model in printer.makeAnnotatedTimeSlotPrintModels(representing: planning, restrictedTo: timeSlot) {
        printAnnotatedTimeSlot(model)
    }
}


func printAnnotatedTimeSlot(_ model: AnnotatedTimeSlotPrintModel) {
    
    print("* \(model.head)")
    print("  \(DateFormatter.localizedString(from: model.timeSlot.startDate, dateStyle: .short, timeStyle: .short)) - \(model.title)")
    if let subtitle = model.subtitle {
        print("                     \(subtitle)")
    }
    if let extra = model.extra {
        print("                     \(extra)")
    }
    print("  \(DateFormatter.localizedString(from: model.timeSlot.endDate, dateStyle: .short, timeStyle: .short))")
    print()
}
