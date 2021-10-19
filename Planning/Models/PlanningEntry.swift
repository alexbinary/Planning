
import Foundation



/// A type that represents an entry in a planning.
///
/// An entry in a planning corresponds to a task positionned on a specific time slot.
/// You create an entry by passing the task and the time slot.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2)
/// let entry = PlanningEntry(withTask: task, on: timeSlot)
/// ```
///
/// Entries are assigned a unique identifier. This identiier is readonly.
/// When checking for equality, only this identifier is compared.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2
///
/// let entry1 = PlanningEntry(withTask: task, on: timeSlot)
/// let entry2 = PlanningEntry(withTask: task, on: timeSlot)
/// var entry3 = entry1
/// entry3.feedback = .taskCompletedWithoutProblem
///
/// entry1 == entry2 // false
/// entry1 == entry3 // true
/// ```
///
struct PlanningEntry: Codable, Equatable
{
    
    /// The unique identifier for this entry.
    ///
    /// When checking for equality, only this identifier is compared.
    ///
    let id: UUID
    
    
    /// The task that this entry positions on the planning.
    ///
    let task: Task
    
    
    /// The time slot that this entry positions the task on.
    ///
    let timeSlot: TimeSlot
    
    
    /// The feedback given on this entry.
    ///
    /// Feedback on planning entries is usefull to improve planning algorithms in the future.
    ///
    var feedback: PlanningEntryFeedback?
    
    
    
    /// Creates a new entry with a given task and time slot.
    ///
    init(withTask task: Task, on timeSlot: TimeSlot) {
        
        self.id = UUID()
        self.task = task
        self.timeSlot = timeSlot
        self.feedback = nil
    }
    
    
    
    /// Compares two instances to see if they are the same.
    ///
    /// Equality only checks the entries identifier.
    ///
    /// ```swift
    /// let task = Task(withName: "t1")
    /// let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2
    ///
    /// let entry1 = PlanningEntry(withTask: task, on: timeSlot)
    /// let entry2 = PlanningEntry(withTask: task, on: timeSlot)
    /// var entry3 = entry1
    /// entry3.feedback = .taskCompletedWithoutProblem
    ///
    /// entry1 == entry2 // false
    /// entry1 == entry3 // true
    /// ```
    ///
    static func == (lhs: PlanningEntry, rhs: PlanningEntry) -> Bool {
        
        return lhs.id == rhs.id
    }
}
