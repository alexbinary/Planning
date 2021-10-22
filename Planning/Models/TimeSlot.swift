
import Foundation



/// A type that represents a moment in time between two dates.
///
/// You can create a time slot by specifying a start date and a duration, or a start date and an end date.
///
/// ```swift
/// let timeSlot1 = TimeSlot(withStartDate: .referenceDate, duration: 2.hours)
/// let timeSlot2 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)
/// timeSlot1 == timeSlot2   // true
/// ```
///
/// No matter how a time slot was created, a time slot exposes the date at which the moment ends.
///
/// ```swift
/// print(timeSlot.endDate) // .referenceDate + 2.hours
/// ```
///
/// A valid time slot has a non zero duration.
/// If you attempt to create a time slot with an end date prior or equal to the start date, or with a zero or negative duration, you get `nil`.
///
/// ```swift
/// let timeSlot = TimeSlot(withStartDate: .referenceDate, duration: 0) // nil
/// let timeSlot = TimeSlot(withStartDate: .referenceDate, duration: -2) // nil
/// let timeSlot = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 1.hours) // nil
/// let timeSlot = TimeSlot(between: .referenceDate, and: .referenceDate) // nil
/// ```
///
/// Time slots can check if they intersect with each other, and even return a time slot that corresponds the their common portion.
///
/// ```swift
/// let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)
/// let timeSlot2 = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 3.hours)
///
/// timeSlot1.intersects(with: timeSlot2)  // true
/// timeSlot1.intersection(with: timeSlot2) // TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 2.hours)
/// ```
///
/// The start and end dates of a time slot make a half open interval `[ start ; end [`, such that the end date is not included in the time slot.
/// As a consequence, two time slots such that the second one has a start date equal to the end date of the first one do not intersect.
///
/// ```swift
/// let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)
/// let timeSlot2 = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)
///
/// timeSlot1.intersects(with: timeSlot2)  // false
/// ```
///
struct TimeSlot: Codable, Equatable
{
    
    /// The date at which the moment starts.
    ///
    var startDate: Date
    
    
    /// The duration of the moment.
    ///
    var duration: TimeInterval
    
    
    /// The date at which the moment ends.
    ///
    var endDate: Date { self.startDate.addingTimeInterval(self.duration) }
    
    
    
    /// Creates a new time slot from a start date and a duration.
    ///
    init?(withStartDate startDate: Date, duration: TimeInterval)
    {
        guard duration > 0 else { return nil }
        
        self.startDate = startDate
        self.duration = duration
    }
    
    
    /// Creates a new time slot from a start date and an end date.
    ///
    init?(between startDate: Date, and endDate: Date)
    {
        guard endDate > startDate else { return nil }
        
        self.startDate = startDate
        self.duration = endDate.timeIntervalSince(startDate)
    }
    
    
    
    /// Returns the common portion, if any, of two time slots.
    ///
    /// If the given time slots overlap, this method returns a time slot that correspond to their common portion.
    ///
    /// ```swift
    /// let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)
    /// let timeSlot2 = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 3.hours)
    ///
    /// TimeSlot.intersection(between: timeSlot1, and: timeSlot2)  // TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 2.hours))
    /// ```
    ///
    /// If the given time slots do not overlap, this method returns `nil`.
    ///
    /// ```swift
    /// let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)
    /// let timeSlot2 = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 3.hours))
    ///
    /// TimeSlot.intersection(between: timeSlot1, and: timeSlot2)  // nil
    /// ```
    ///
    /// The start and end dates of a time slot make a half open interval `[ start ; end [`, such that the end date is not included in the time slot.
    /// As a consequence, two time slots such that the second one has a start date equal to the end date of the first one do not intersect.
    ///
    /// ```swift
    /// let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)
    /// let timeSlot2 = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)
    ///
    /// TimeSlot.intersection(between: timeSlot1, and: timeSlot2)  // false
    /// ```
    ///
    /// Note that `intersection(between: timeSlot1, and: timeSlot2)` always produces the same result than `intersection(between: timeSlot2, and: timeSlot1)`.
    /// In other words, the order in which the time slots are given has no effect.
    ///
    static func intersection(between timeSlot1: TimeSlot, and timeSlot2: TimeSlot) -> TimeSlot? {
        
        let latestStartDate = [timeSlot1.startDate, timeSlot2.startDate].max()!
        let earliestEndDate = [timeSlot1.endDate, timeSlot2.endDate].min()!
        
        return TimeSlot(between: latestStartDate, and: earliestEndDate)
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
