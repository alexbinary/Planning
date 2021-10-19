
import Foundation



struct DataModel: Codable
{
    var planning: Planning
    var backlog: Backlog
    
    mutating func addToBacklog(_ task: Task) {
        
        self.backlog.tasks.append(task)
    }
    
    mutating func deleteFromBacklog(taskWithId id: UUID) {
        
        self.backlog.tasks.removeAll(where: { $0.id == id })
    }
    
    mutating func addToPlanning(_ task: Task, startingAt startingDate: Date, duration: TimeInterval) {
        
        self.planning.items.append(PlanningItem(withTask: task, startingAt: startingDate, duration: duration))
    }
    
    mutating func deleteFromPlanning(itemWithId id: UUID) {
        
        self.planning.items.removeAll(where: { $0.id == id })
    }
}
