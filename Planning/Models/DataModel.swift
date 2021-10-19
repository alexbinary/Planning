
import Foundation



struct DataModel: Codable
{
    var planning: Planning
    var backlog: Backlog
    
    mutating func addToBacklog(_ task: Task) -> Task {
        
        self.backlog.tasks.append(task)
        return task
    }
    
    mutating func deleteFromBacklog(taskWithId id: UUID) {
        
        self.backlog.tasks.removeAll(where: { $0.id == id })
    }
    
    mutating func clearBacklog() {
        
        self.backlog.tasks.removeAll()
    }
    
    mutating func addToPlanning(_ task: Task, on timeSlot: TimeSlot) -> PlanningEntry {
        
        let entry = PlanningEntry(withTask: task, on: timeSlot)
        self.planning.entries.append(entry)
        return entry
    }
    
    mutating func deleteFromPlanning(entryWithId id: UUID) {
        
        self.planning.entries.removeAll(where: { $0.id == id })
    }
    
    mutating func clearPlanning() {
        
        self.planning.entries.removeAll()
    }
    
    mutating func giveFeedback(_ feedback: PlanningEntryFeedback, onPlanningEntryWithId id: UUID) {
        
        let index = self.planning.entries.firstIndex(where: { $0.id == id })!
        self.planning.entries[index].feedback = feedback
    }
    
    func planningFeedbackScore(between slotStartDate: Date, and slotEndDate: Date) -> Float {
        
        let entriesInSlot = self.planning.entries.filter { $0.timeSlot.startDate >= slotStartDate && $0.timeSlot.startDate <= slotEndDate }
        
        return Float(entriesInSlot.filter { $0.feedback == .taskCompletedWithoutProblem } .count) / Float(entriesInSlot.count)
    }
    
    mutating func fillPlanning(from slotStartDate: Date, to slotEndDate: Date) {
        
        var taskStartDate = slotStartDate
        let taskDuration: TimeInterval = 30*60
        
        while self.planning.mostRecentEntryEndDate == nil || self.planning.mostRecentEntryEndDate! < slotEndDate {
            for task in self.backlog.tasks {
                
                let entry = self.addToPlanning(task, on: TimeSlot(withStartDate: taskStartDate, duration: taskDuration))
                if entry.timeSlot.endDate >= slotEndDate {
                    return
                }
                taskStartDate = entry.timeSlot.endDate
            }
        }
    }
    
    mutating func fillPlanningForNext24HoursAfterLatestEntry() {
        
        let slotStartDate = self.planning.mostRecentEntryEndDate ?? Date()
        let slotEndDate = Calendar.current.date(byAdding: .hour, value: 24, to: slotStartDate)!
        
        self.fillPlanning(from: slotStartDate, to: slotEndDate)
    }
}
