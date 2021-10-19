
import Foundation



struct PlanningEntry: Codable, Equatable
{
    let id: UUID
    let task: Task
    let timeSlot: TimeSlot
    var feedback: PlanningEntryFeedback?
    
    init(withTask task: Task, startingAt startDate: Date, duration: TimeInterval) {
        
        self.id = UUID()
        self.task = task
        self.timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        self.feedback = nil
    }
    
    static func == (lhs: PlanningEntry, rhs: PlanningEntry) -> Bool {
        
        return lhs.id == rhs.id
    }
}
