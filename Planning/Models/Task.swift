
import Foundation



/// A type that represents an activity that should be performed.
///
/// To create a task, you pass the name of the task.
///
/// ```swift
/// let task = Task(withName: "fix bugs")
/// ```
///
/// By default, tasks are scheduled for a duration that corresponds to the planning's unit time slot.
///
/// If you want the task to be scheduled for a specific duration, you can pass an optional reference duration when creating the task.
/// If a reference duration is set, the task will be scheduled for this exact duration.
///
/// ```swift
/// let task = Task(withName: "fix bugs", referenceDuration: 30.minutes)
/// // will always be scheduled for 30 minutes
/// ```
///
/// To add more flexibility, you can specify a minimum duration.
/// If a minimum duration is set, the duration allocated to the task can be reduced up to that duration so that the task can be scheduled in a smaller time slot.
///
/// ```swift
/// let task = Task(withName: "write doc", referenceDuration: 40.minutes, minimumDuration: 10.minutes)
/// // can be scheduled from 10 up to 40 minutes
/// ```
///
/// Tasks are automatically assigned a unique identifier.
/// The task identiier is readonly and cannot be changed.
/// Two tasks are considered the same as long as they have the same identifier.
///
///```swift
/// let task1 = Task(withName: "fix bugs")
/// let task2 = Task(withName: "fix bugs")
/// task1 == task2 // false
///
/// let task3 = task1
/// task1 == task3 // true
/// ```
///
struct Task: Codable, Equatable
{
    
    /// The unique identifier for the task.
    ///
    /// The identifier is used as reference when checking if two tasks are the same.
    /// Two tasks with the same identifier are considered the same, even if other data are different.
    ///
    let id: UUID
    
    
    /// The name of the task.
    ///
    /// The name of the task should be a verbal group, like "fix bugs", or "write documention"
    ///
    let name: String
    
    
    /// The duration that should be allocated to the task.
    ///
    /// By default, tasks are scheduled for a duration that corresponds to the planning's unit time slot.
    /// Use this property to indicate a specific duration the task should be schedule for.
    ///
    let referenceDuration: TimeInterval?
    
    
    /// The minimum duration that should be allocated to the task.
    ///
    /// By default, tasks are scheduled for a fixed duration.
    /// Use this property to indicate that the duration can be reduced up to a specific duration so that the task can be scheduled in a smaller time slot to accomodate planning constraints.
    
    /// If the minimum duration is `nil`, the duration will not be reduced below the reference duration if it is set or the planning unit time slot.
    ///
    let minimumDuration: TimeInterval?
    
    
    
    /// Creates a new task with a given name.
    ///
    init(withName name: String, referenceDuration: TimeInterval? = nil, minimumDuration: TimeInterval? = nil) {
        
        self.id = UUID()
        self.name = name
        self.referenceDuration = referenceDuration
        self.minimumDuration = minimumDuration
    }
    
    
    
    /// Compares two instances to see if they are the same.
    ///
    /// Equality only checks the identifier.
    ///
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.id == rhs.id
    }
}
