
import Foundation



struct DataModel: Codable
{
    let planning: Planning
    var backlog: Backlog
    
    mutating func addToBacklog(_ task: Task) {
        
        self.backlog.tasks.append(task)
    }
    
    mutating func deleteFromBacklog(taskWithId id: UUID) {
        
        self.backlog.tasks.removeAll(where: { $0.id == id })
    }
}
