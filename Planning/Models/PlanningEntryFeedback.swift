
import Foundation



/// A type used to provide feedback on a planning entry.
///
/// Feedback on planning entries is usefull to improve planning algorithms in the future.
/// You give feedback on planning entries to indicate how the planning entry performed in reality.
///
enum PlanningEntryFeedback: String, Codable, CustomStringConvertible
{
    
    /// Indicates that the task could be performed without any issue.
    ///
    /// Give this kind of feedback to indicate that the day, time slot and/or the arrangement with other tasks that came before or after was appropriate for the task.
    /// Tasks with this kind of feedback have no reasons to be scheduled differently in the future.
    ///
    case taskCompletedWithoutProblem
    
    
    /// Indicates that the task could not be performed correctly or at all.
    ///
    /// Give this kind of feedback to indicate that the scheduling of the task was not appropriate and lead to an inability to perform the task.
    /// Scheduling for tasks with this kind of feedback needs to be improved in the future.
    ///
    case taskCouldNotBeDoneCorrectlyOrDoneAtAll
    
    
    /// Provides a textual representation of this enum case.
    ///
    /// This is used when printing a value of this type.
    ///
    var description: String { self.rawValue }
}
