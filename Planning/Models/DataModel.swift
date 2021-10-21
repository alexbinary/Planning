
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
    
    mutating func addToPlanning(_ task: Task, on timeSlot: TimeSlot) -> TaskScheduling {
        
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        self.planning.taskSchedulings.append(scheduling)
        return scheduling
    }
    
    mutating func deleteFromPlanning(taskSchedulingWithId id: UUID) {
        
        self.planning.taskSchedulings.removeAll(where: { $0.id == id })
    }
    
    mutating func clearPlanning() {
        
        self.planning.taskSchedulings.removeAll()
    }
    
    mutating func move(taskSchedulingWithId id: UUID, toNewStartDate newStartDate: Date) -> TaskScheduling {
        
        let index = self.planning.taskSchedulings.firstIndex(where: { $0.id == id })!
        
        self.planning.taskSchedulings[index].timeSlot.startDate = newStartDate
        
        return self.planning.taskSchedulings[index]
    }
    
    func taskSchedulings(intersectingWith timeSlot: TimeSlot? = nil) -> [TaskScheduling] {
        
        if let timeSlot = timeSlot {
            return self.planning.taskSchedulings.filter { $0.timeSlot.intersects(with: timeSlot) }
        } else {
            return self.planning.taskSchedulings
        }
    }
    
    mutating func giveFeedback(_ feedback: TaskSchedulingFeedback, onTaskSchedulingWithId id: UUID) {
        
        let index = self.planning.taskSchedulings.firstIndex(where: { $0.id == id })!
        self.planning.taskSchedulings[index].feedback = feedback
    }
    
    func planningFeedbackScore(on timeSlot: TimeSlot) -> Float {
        
        let taskSchedulingsInSlot = self.taskSchedulings(intersectingWith: timeSlot)
        
        return Float(taskSchedulingsInSlot.filter { $0.feedback == .taskCompletedWithoutProblem } .count) / Float(taskSchedulingsInSlot.count)
    }
    
    mutating func fillPlanning(on timeSlot: TimeSlot) {
        
        var taskStartDate = timeSlot.startDate
        let taskDuration: TimeInterval = 30*60
        
        while self.planning.mostRecentTaskSchedulingEndDate == nil || self.planning.mostRecentTaskSchedulingEndDate! < timeSlot.endDate {
            for task in self.backlog.tasks {
                
                let taskScheduling = self.addToPlanning(task, on: TimeSlot(withStartDate: taskStartDate, duration: taskDuration))
                if taskScheduling.timeSlot.endDate >= timeSlot.endDate {
                    return
                }
                taskStartDate = taskScheduling.timeSlot.endDate
            }
        }
    }
    
    mutating func fillPlanningForNext24HoursAfterLatestTaskScheduling() {
        
        let slotStartDate = self.planning.mostRecentTaskSchedulingEndDate ?? Date()
        let slotEndDate = Calendar.current.date(byAdding: .hour, value: 24, to: slotStartDate)!
        
        self.fillPlanning(on: TimeSlot(between: slotStartDate, and: slotEndDate))
    }
}
