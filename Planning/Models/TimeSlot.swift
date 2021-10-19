
import Foundation



/// A type that represents a moment in time between two dates.
///
/// You create a time slot by specifying a start date and a duration.
///
/// ```swift
/// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2)
/// ```
///
/// A time slot exposes the date at which the moment ends.
///
/// ```swift
/// print(timeSlot.endDate) // Date() + 2 seconds
/// ```
///
struct TimeSlot: Codable
{
    
    /// The date at which the moment starts.
    ///
    let startDate: Date
    
    
    /// The duration of the moment.
    ///
    let duration: TimeInterval
    
    
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
}
