
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
    
    mutating func clearBacklog() {
        
        self.backlog.tasks.removeAll()
    }
    
    mutating func addToPlanning(_ task: Task, startingAt startingDate: Date, duration: TimeInterval) {
        
        self.planning.entries.append(PlanningEntry(withTask: task, startingAt: startingDate, duration: duration))
    }
    
    mutating func deleteFromPlanning(entryWithId id: UUID) {
        
        self.planning.entries.removeAll(where: { $0.id == id })
    }
    
    mutating func fillPlanning(from slotStartDate: Date, to slotEndDate: Date) {
        
        var taskStartDate = slotStartDate
        let taskDuration: TimeInterval = 30*60
        
        for task in self.backlog.tasks {
            
            self.addToPlanning(task, startingAt: taskStartDate, duration: taskDuration)
            taskStartDate.addTimeInterval(taskDuration)
        }
    }
    
    mutating func fillPlanningForNext24HoursAfterLatestEntry() {
        
        let slotStartDate = self.planning.mostRecentEntryEndDate ?? Date()
        let slotEndDate = Calendar.current.date(byAdding: .hour, value: 24, to: slotStartDate)!
        
        self.fillPlanning(from: slotStartDate, to: slotEndDate)
    }
}
