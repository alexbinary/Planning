
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
/// Time slots can check if they intersect with each other, and even return a time slot that corresponds the their common portion.
///
/// ```swift
/// let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 2))
/// let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 3))
///
/// timeSlot1.intersects(with: timeSlot2)  // true
/// timeSlot1.intersection(with: timeSlot2) // TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 2))
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
    
    
    
    /// Returns the common portion, if any, of two time slots.
    ///
    /// If the given time slots overlap, this method returns a time slot that correspond to their common portion.
    ///
    /// ```swift
    /// let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 2))
    /// let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 3))
    ///
    /// TimeSlot.intersection(between: timeSlot1, and: timeSlot2)  // TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 2))
    ///
    /// let timeSlot3 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
    /// let timeSlot4 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 2), and: Date(timeIntervalSinceReferenceDate: 3))
    ///
    /// TimeSlot.intersection(between: timeSlot3, and: timeSlot4))  // nil
    /// ```
    ///
    /// Note that `intersection(between: timeSlot1, and: timeSlot2)` always produces the same result than `intersection(between: timeSlot2, and: timeSlot1)`.
    /// In other words, the order in which the time slots are given has no effect.
    ///
    static func intersection(between timeSlot1: TimeSlot, and timeSlot2: TimeSlot) -> TimeSlot? {
        
        let latestStartDate = [timeSlot1.startDate, timeSlot2.startDate].max()!
        let earliestEndDate = [timeSlot1.endDate, timeSlot2.endDate].min()!
        
        return latestStartDate < earliestEndDate ? TimeSlot(between: latestStartDate, and: earliestEndDate) : nil
    }
    
    
    /// Returns the common portion, if any, that this instance shares with another time slot.
    ///
    /// See `intersection(between:and:)` for more details about time slots intersections.
    ///
    func intersection(with otherTimeSlot: TimeSlot) -> TimeSlot? {
        
        return Self.intersection(between: self, and: otherTimeSlot)
    }
    
    
    /// Returns whether this instance shares a common portion with another time slot.
    ///
    /// See `intersection(between:and:)` for more details about time slots intersections.
    ///
    func intersects(with otherTimeSlot: TimeSlot) -> Bool {
        
        return intersection(with: otherTimeSlot) != nil
    }
}
