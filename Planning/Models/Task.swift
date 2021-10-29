
import Foundation



/// A type that represents an activity that should be performed.
///
/// To create a task, you pass the name of the task.
///
/// ```swift
/// let task = Task(withName: "fix bugs")
/// ```
///
/// A task also has an optional reference duration that you can specify when creating the task.
///
/// ```swift
/// let task = Task(withName: "fix bugs", referenceDuration: 30.minutes)
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
    
    
    /// The duration that should be used as reference when scheduling the task.
    ///
    let referenceDuration: TimeInterval?
    
    
    
    /// Creates a new task with a given name.
    ///
    init(withName name: String, referenceDuration: TimeInterval? = nil) {
        
        self.id = UUID()
        self.name = name
        self.referenceDuration = referenceDuration
    }
    
    
    
    /// Compares two instances to see if they are the same.
    ///
    /// Equality only checks the identifier.
    ///
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.id == rhs.id
    }
}
