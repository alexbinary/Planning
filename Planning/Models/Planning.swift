
import Foundation



/// A type that represents a planning.
///
/// A planning positionnes tasks and other pieces of information on time slots.
///
struct Planning: Codable
{
    
    /// The tasks schedulings that the planning stores.
    ///
    var taskSchedulings: [TaskScheduling]
    
    
    /// The tasks schedulings ordered by their start date, with the oldest start date first.
    ///
    var taskSchedulingsOrderedByStartDateOldestFirst: [TaskScheduling] { self.taskSchedulings.sorted(by: { $0.timeSlot.startDate < $1.timeSlot.startDate }) }
    
    
    /// Returns the date of the task scheduling that ends the most recently.
    ///
    var mostRecentTaskSchedulingEndDate: Date? { self.taskSchedulings.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })?.timeSlot.endDate }
    
    
    
    mutating func schedule(_ task: Task, on timeSlot: TimeSlot) -> TaskScheduling {
        
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        self.taskSchedulings.append(scheduling)
        return scheduling
    }
    
    
    mutating func delete(taskSchedulingWithId id: UUID) {
        
        self.taskSchedulings.removeAll(where: { $0.id == id })
    }
    
    
    mutating func clear() {
        
        self.taskSchedulings.removeAll()
    }
    
    
    mutating func move(taskSchedulingWithId id: UUID, toNewStartDate newStartDate: Date) -> TaskScheduling {
        
        let index = self.taskSchedulings.firstIndex(where: { $0.id == id })!
        
        self.taskSchedulings[index].timeSlot.startDate = newStartDate
        
        return self.taskSchedulings[index]
    }
    
    
    func taskSchedulings(intersectingWith timeSlot: TimeSlot? = nil) -> [TaskScheduling] {
        
        if let timeSlot = timeSlot {
            return self.taskSchedulings.filter { $0.timeSlot.intersects(with: timeSlot) }
        } else {
            return self.taskSchedulings
        }
    }
    
    
    mutating func giveFeedback(_ feedback: TaskSchedulingFeedback, onTaskSchedulingWithId id: UUID) {
        
        let index = self.taskSchedulings.firstIndex(where: { $0.id == id })!
        self.taskSchedulings[index].feedback = feedback
    }
    
    
    func feedbackScore(on timeSlot: TimeSlot) -> Float {
        
        let taskSchedulingsInSlot = self.taskSchedulings(intersectingWith: timeSlot)
        
        return Float(taskSchedulingsInSlot.filter { $0.feedback == .taskCompletedWithoutProblem } .count) / Float(taskSchedulingsInSlot.count)
    }
    
    
    mutating func fill(on timeSlot: TimeSlot, using backlog: Backlog) {
        
        var referenceDate = timeSlot.startDate
        
        while true {
            for task in backlog.tasks {
                
                let taskDuration = task.referenceDuration ?? 30.minutes
                let taskScheduling = self.schedule(task, on: TimeSlot(withStartDate: referenceDate, duration: taskDuration))
                if taskScheduling.timeSlot.endDate >= timeSlot.endDate {
                    return
                }
                referenceDate = taskScheduling.timeSlot.endDate
            }
        }
    }
    
    
    mutating func fillForNext24HoursAfterLatestTaskScheduling(using backlog: Backlog) {
        
        let slotStartDate = self.mostRecentTaskSchedulingEndDate ?? Date()
        let slotEndDate = Calendar.current.date(byAdding: .hour, value: 24, to: slotStartDate)!
        
        self.fill(on: TimeSlot(between: slotStartDate, and: slotEndDate), using: backlog)
    }
}
