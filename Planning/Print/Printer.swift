
import Foundation



/// A type that computes data that should be presented to the user from model data.
///
struct Printer
{
    
    /// Returns the data that should be presented to the user to communicate tasks scheduled on a planning on a given optional time slot.
    ///
    /// - Parameter dataModel The data model scheduled tasks should be read from.
    /// - Parameter timeSlot If provided, only tasks whose scheduling intersects with the time slot are used. Otherwise, all scheduled tasks are used.
    ///
    func annotatedTimeSlotPrintModelsForPlanning(from dataModel: DataModel, on timeSlot: TimeSlot? = nil) -> [AnnotatedTimeSlotPrintModel] {
        
        var models: [AnnotatedTimeSlotPrintModel] = []
        
        var latestReferenceDate: Date? = nil
        
        if let timeSlot = timeSlot {
            latestReferenceDate = timeSlot.startDate
        }
        
        for taskScheduling in dataModel.taskSchedulings(intersectingWith: timeSlot) {
            
            if let latestReferenceDate = latestReferenceDate,
               taskScheduling.timeSlot.startDate > latestReferenceDate {
                
                let model = makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: latestReferenceDate, and: taskScheduling.timeSlot.startDate))
                models.append(model)
            }
            
            let model = makeAnnotatedTimeSlotPrintModel(representing: taskScheduling)
            models.append(model)
            
            latestReferenceDate = taskScheduling.timeSlot.endDate
        }
        
        if let timeSlot = timeSlot,
           let latestReferenceDate = latestReferenceDate,
           latestReferenceDate < timeSlot.endDate {
        
            let model = makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: latestReferenceDate, and: timeSlot.endDate))
            models.append(model)
        }
        
        return models
    }


    func makeAnnotatedTimeSlotPrintModel(representing taskScheduling: TaskScheduling) -> AnnotatedTimeSlotPrintModel {
        
        return AnnotatedTimeSlotPrintModel(
            timeSlot: taskScheduling.timeSlot,
            head: "\(taskScheduling.id)",
            title: "\(taskScheduling.task.id)",
            subtitle: "\(taskScheduling.task.name)",
            extra: "Feedback: \(taskScheduling.feedback?.description ?? "-")"
        )
    }


    func makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(_ timeSlot: TimeSlot) -> AnnotatedTimeSlotPrintModel {
        
        return AnnotatedTimeSlotPrintModel(
            timeSlot: timeSlot,
            head: "(Empty)",
            title: "Empty",
            subtitle: nil,
            extra: nil
        )
    }
}
