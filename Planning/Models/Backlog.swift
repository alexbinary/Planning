
import Foundation



struct Backlog: Codable
{
    
    var tasks: [Task]
    
    
    mutating func add(_ task: Task) -> Task {
        
        self.tasks.append(task)
        return task
    }
    
    
    mutating func delete(taskWithId id: UUID) {
        
        self.tasks.removeAll(where: { $0.id == id })
    }
    
    
    mutating func clear() {
        
        self.tasks.removeAll()
    }
}
