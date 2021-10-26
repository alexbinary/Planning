
import Foundation



/// A type that associates a task with a time slot.
///
/// A task scheduling positionns a task on a specific time slot.
/// You create a task scheduling by passing the task and the time slot.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2.hours)
/// let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
/// ```
/// 
/// Task schedulings are automatically assigned a unique identifier.
/// The task scheduling identiier is readonly and cannot be changed.
/// The task scheduling identifier is used as reference when checking if two task schedulings are the same.
///
/// ```swift
/// let task = Task(withName: "t1")
/// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2.hours)
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
    
    /// The unique identifier for the task scheduling.
    ///
    /// The identifier is used as reference when checking if two task schedulings are the same.
    /// Two task schedulings with the same identifier are considered the same, even if other data are different.
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
    /// let timeSlot = TimeSlot(withStartDate: Date(), duration: 2.hours)
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



extension Array where Element == TaskScheduling {
    

    /// Returns the elements of the array, sorted by start date, oldest first.
    ///
    var sortedByStartDate: [TaskScheduling] {
        
        self.sorted(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })
    }
}
