
import Foundation



/// A type that computes data that should be presented to the user from model data.
///
struct Printer
{
    
    /// Returns the data that should be presented to the user to communicate planning entries on a given optional time slot.
    ///
    /// - Parameter dataModel The data model planning entries should be read from
    /// - Parameter timeSlot If provided, only planning entries that intersect with the time slot are used. Otherwise, all entries are used.
    ///
    func annotatedTimeSlotPrintModelsForPlanning(from dataModel: DataModel, on timeSlot: TimeSlot? = nil) -> [AnnotatedTimeSlotPrintModel] {
        
        var models: [AnnotatedTimeSlotPrintModel] = []
        
        var latestReferenceDate: Date? = nil
        
        if let timeSlot = timeSlot {
            latestReferenceDate = timeSlot.startDate
        }
        
        for entry in dataModel.planningEntries(in: timeSlot) {
            
            if let latestReferenceDate = latestReferenceDate,
               entry.timeSlot.startDate > latestReferenceDate {
                
                let model = makeAnnotatedTimeSlotPrintModelForEmptyPlanningEntry(on: TimeSlot(between: latestReferenceDate, and: entry.timeSlot.startDate))
                models.append(model)
            }
            
            let model = makeAnnotatedTimeSlotPrintModel(for: entry)
            models.append(model)
            
            latestReferenceDate = entry.timeSlot.endDate
        }
        
        if let timeSlot = timeSlot,
           let latestReferenceDate = latestReferenceDate,
           latestReferenceDate < timeSlot.endDate {
        
            let model = makeAnnotatedTimeSlotPrintModelForEmptyPlanningEntry(on: TimeSlot(between: latestReferenceDate, and: timeSlot.endDate))
            models.append(model)
        }
        
        return models
    }


    func makeAnnotatedTimeSlotPrintModel(for entry: PlanningEntry) -> AnnotatedTimeSlotPrintModel {
        
        return AnnotatedTimeSlotPrintModel(
            timeSlot: entry.timeSlot,
            head: "\(entry.id)",
            title: "\(entry.task.id)",
            subtitle: "\(entry.task.name)",
            extra: "Feedback: \(entry.feedback?.description ?? "-")"
        )
    }


    func makeAnnotatedTimeSlotPrintModelForEmptyPlanningEntry(on timeSlot: TimeSlot) -> AnnotatedTimeSlotPrintModel {
        
        return AnnotatedTimeSlotPrintModel(
            timeSlot: timeSlot,
            head: "(Empty)",
            title: "Empty",
            subtitle: nil,
            extra: nil
        )
    }
}
