
import Foundation



/// A type that represents a planning.
///
/// A planning positionnes tasks and other pieces of information on time slots.
///
struct Planning: Codable
{
    
    /// The tasks schedulings that the planning stores.
    ///
    var taskSchedulings: [TaskScheduling]
    
    
    /// The tasks schedulings ordered by their start date, with the oldest start date first.
    ///
    var taskSchedulingsOrderedByStartDateOldestFirst: [TaskScheduling] { self.taskSchedulings.sorted(by: { $0.timeSlot.startDate < $1.timeSlot.startDate }) }
    
    
    /// Returns the date of the task scheduling that ends the most recently.
    ///
    var mostRecentTaskSchedulingEndDate: Date? { self.taskSchedulings.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })?.timeSlot.endDate }
}
