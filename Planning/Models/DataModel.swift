
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
    
    mutating func fillPlanning(from slotStartDate: Date, to slotEndDate: Date) {
        
        var taskStartDate = slotStartDate
        let taskDuration: TimeInterval = 30*60
        
        for task in self.backlog.tasks {
            
            self.addToPlanning(task, startingAt: taskStartDate, duration: taskDuration)
            taskStartDate.addTimeInterval(taskDuration)
        }
    }
    
    mutating func fillPlanningForNext24HoursAfterLatestItem() {
        
        let slotStartDate = self.planning.mostRecentItemEndDate ?? Date()
        let slotEndDate = Calendar.current.date(byAdding: .hour, value: 24, to: slotStartDate)!
        
        self.fillPlanning(from: slotStartDate, to: slotEndDate)
    }
}
