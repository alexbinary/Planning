
import Foundation



struct PlanningItem: Codable, Equatable
{
    let id: UUID
    let task: Task
    let startDate: Date
    let duration: TimeInterval
    var endDate: Date { self.startDate.addingTimeInterval(self.duration) }
    
    init(withTask task: Task, startingAt startDate: Date, duration: TimeInterval) {
        
        self.id = UUID()
        self.task = task
        self.startDate = startDate
        self.duration = duration
    }
    
    static func == (lhs: PlanningItem, rhs: PlanningItem) -> Bool {
        
        return lhs.id == rhs.id
    }
}
