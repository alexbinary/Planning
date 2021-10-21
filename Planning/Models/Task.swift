
import Foundation



/// A type that represents an activity that should be performed.
///
/// To create a task, you pass the name of the task.
///
/// ```swift
/// let task = Task(withName: "fix bugs")
/// ```
///
/// Tasks are automatically assigned a unique identifier.
/// The task identiier is readonly and cannot be changed.
/// The task identifier is used as reference when checking if two tasks are the same.
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
    
    
    
    /// Creates a new task with a given name.
    ///
    init(withName name: String) {
        
        self.id = UUID()
        self.name = name
    }
    
    
    
    /// Compares two instances to see if they are the same.
    ///
    /// Equality only checks the identifier.
    ///
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.id == rhs.id
    }
}
