
import Foundation



/// A type that represents a moment in time between two dates.
///
/// You can create a time slot by specifying a start date and a duration, or a start date and an end date.
///
/// ```swift
/// let timeSlot1 = TimeSlot(withStartDate: Date(), duration: 2)
/// let timeSlot2 = TimeSlot(withStartDate: Date(), duration: Date().addingTimeInterval(2))
/// ```
///
/// No matter how a time slot was created, a time slot exposes the date at which the moment ends.
///
/// ```swift
/// print(timeSlot.endDate) // Date() + 2 seconds
/// ```
///
struct TimeSlot: Codable, Equatable
{
    
    /// The date at which the moment starts.
    ///
    let startDate: Date
    
    
    /// The duration of the moment.
    ///
    var duration: TimeInterval
    
    
    /// The date at which the moment ends.
    ///
    var endDate: Date { self.startDate.addingTimeInterval(self.duration) }
    
    
    
    /// Creates a new time slot from a start date and a duration.
    ///
    init(withStartDate startDate: Date, duration: TimeInterval)
    {
        self.startDate = startDate
        self.duration = duration
    }
    
    
    /// Creates a new time slot from a start date and an end date.
    ///
    init(between startDate: Date, and endDate: Date)
    {
        self.startDate = startDate
        self.duration = endDate.timeIntervalSince(startDate)
    }
}
