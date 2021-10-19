
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
    
    func planningFeedbackScore(on timeSlot: TimeSlot) -> Float {
        
        let entriesInSlot = self.planning.entries.filter { $0.timeSlot.startDate >= timeSlot.startDate && $0.timeSlot.startDate <= timeSlot.endDate }
        
        return Float(entriesInSlot.filter { $0.feedback == .taskCompletedWithoutProblem } .count) / Float(entriesInSlot.count)
    }
    
    mutating func fillPlanning(on timeSlot: TimeSlot) {
        
        var taskStartDate = timeSlot.startDate
        let taskDuration: TimeInterval = 30*60
        
        while self.planning.mostRecentEntryEndDate == nil || self.planning.mostRecentEntryEndDate! < timeSlot.endDate {
            for task in self.backlog.tasks {
                
                let entry = self.addToPlanning(task, on: TimeSlot(withStartDate: taskStartDate, duration: taskDuration))
                if entry.timeSlot.endDate >= timeSlot.endDate {
                    return
                }
                taskStartDate = entry.timeSlot.endDate
            }
        }
    }
    
    mutating func fillPlanningForNext24HoursAfterLatestEntry() {
        
        self.fillPlanning(on: TimeSlot(withStartDate: self.planning.mostRecentEntryEndDate ?? Date(), duration: 24*3600))
    }
}
