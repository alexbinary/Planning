
import Foundation



/// A type that associates a task with a time slot.
///
/// A task scheduling positionns a task on a specific time slot.
/// You create a task scheduling by passing the task and the time slot.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2)
/// let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
/// ```
///
/// Tasks schedulings are assigned a unique identifier. This identiier is readonly.
/// When checking for equality, only this identifier is compared.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2
///
/// let scheduling1 = TaskScheduling(scheduling: task, on: timeSlot)
/// let scheduling2 = TaskScheduling(scheduling: task, on: timeSlot)
/// var scheduling3 = scheduling1
/// scheduling3.feedback = .taskCompletedWithoutProblem
///
/// scheduling1 == scheduling2 // false
/// scheduling1 == scheduling3 // true
/// ```
///
struct TaskScheduling: Codable, Equatable
{
    
    /// The unique identifier for this task scheduling.
    ///
    /// When checking for equality, only this identifier is compared.
    ///
    let id: UUID
    
    
    /// The task that is scheduled.
    ///
    let task: Task
    
    
    /// The time slot the task is positionned on.
    ///
    var timeSlot: TimeSlot
    
    
    /// The feedback given on this task scheduling.
    ///
    /// Feedback on task schedulings is usefull to improve scheduling algorithms in the future.
    ///
    var feedback: TaskSchedulingFeedback?
    
    
    
    /// Creates a new task scheduling with a given task and time slot.
    ///
    init(scheduling task: Task, on timeSlot: TimeSlot) {
        
        self.id = UUID()
        self.task = task
        self.timeSlot = timeSlot
        self.feedback = nil
    }
    
    
    
    /// Compares two instances to see if they are the same.
    ///
    /// Equality only checks the identifier.
    ///
    /// ```swift
    /// let task = Task(withName: "t1")
    /// let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2
    ///
    /// let scheduling1 = TaskScheduling(task, on: timeSlot)
    /// let scheduling2 = TaskScheduling(task, on: timeSlot)
    /// var scheduling3 = scheduling1
    /// scheduling3.feedback = .taskCompletedWithoutProblem
    ///
    /// scheduling1 == scheduling2 // false
    /// scheduling1 == scheduling3 // true
    /// ```
    ///
    static func == (lhs: TaskScheduling, rhs: TaskScheduling) -> Bool {
        
        return lhs.id == rhs.id
    }
}
