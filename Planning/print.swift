
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
    
    let printer = Printer()
    
    for model in printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel, on: timeSlot) {
        printTaskScheduling(model: model)
    }
}


func printTaskScheduling(model: AnnotatedTimeSlotPrintModel) {
    
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


