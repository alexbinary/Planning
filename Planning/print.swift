
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
    
    for model in planningEntryPrintModels(from: dataModel, on: timeSlot) {
        printPlanningEntry(model: model)
    }
}


func planningEntryPrintModels(from dataModel: DataModel, on timeSlot: TimeSlot? = nil) -> [PlanningEntryPrintModel] {
    
    var models: [PlanningEntryPrintModel] = []
    
    var latestReferenceDate: Date? = nil
    
    if let timeSlot = timeSlot {
        latestReferenceDate = timeSlot.startDate
    }
    
    for entry in dataModel.planningEntries(in: timeSlot) {
        
        if let latestReferenceDate = latestReferenceDate,
           entry.timeSlot.startDate > latestReferenceDate {
            
            let model = makeEmptyEntryPrintModel(on: TimeSlot(between: latestReferenceDate, and: entry.timeSlot.startDate))
            models.append(model)
        }
        
        let model = makeEntryPrintModel(from: entry)
        models.append(model)
        
        latestReferenceDate = entry.timeSlot.endDate
    }
    
    if let timeSlot = timeSlot,
       let latestReferenceDate = latestReferenceDate,
       latestReferenceDate < timeSlot.endDate {
    
        let model = makeEmptyEntryPrintModel(on: TimeSlot(between: latestReferenceDate, and: timeSlot.endDate))
        models.append(model)
    }
    
    return models
}


func makeEntryPrintModel(from entry: PlanningEntry) -> PlanningEntryPrintModel {
    
    return PlanningEntryPrintModel(
        timeSlot: entry.timeSlot,
        head: "\(entry.id)",
        title: "\(entry.task.id)",
        subtitle: "\(entry.task.name)",
        extra: "Feedback: \(entry.feedback?.description ?? "-")"
    )
}


func makeEmptyEntryPrintModel(on timeSlot: TimeSlot) -> PlanningEntryPrintModel {
    
    return PlanningEntryPrintModel(
        timeSlot: timeSlot,
        head: "(Empty)",
        title: "Empty",
        subtitle: nil,
        extra: nil
    )
}


func printPlanningEntry(model: PlanningEntryPrintModel) {
    
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


struct PlanningEntryPrintModel
{
    let timeSlot: TimeSlot
    let head: String
    let title: String
    let subtitle: String?
    let extra: String?
}
