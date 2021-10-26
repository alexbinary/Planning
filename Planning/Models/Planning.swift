
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
    var taskSchedulingsSortedByStartDate: [TaskScheduling] { self.taskSchedulings.sortedByStartDate }
    
    
    /// Returns the date of the task scheduling that ends the most recently.
    ///
    var mostRecentTaskSchedulingEndDate: Date? { self.taskSchedulings.sortedByEndDate.last?.timeSlot.endDate }
    
    
    
    /// Schedules a task on the planning on the specified time slot.
    ///
    /// - Returns: a `TaskScheduling` object that represents the scheduling of the task that was added to the planning.
    ///
    @discardableResult
    mutating func schedule(_ task: Task, on timeSlot: TimeSlot) -> TaskScheduling {
        
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        self.taskSchedulings.append(scheduling)
        return scheduling
    }
    
    
    /// Deletes a task scheduling from its id.
    ///
    mutating func delete(taskSchedulingWithId taskSchedulingId: UUID) throws {
        
        guard self.taskSchedulings.contains(where: { $0.id == taskSchedulingId }) else { throw PlanningError.objectNotFound(id: taskSchedulingId) }
        
        self.taskSchedulings.removeAll(where: { $0.id == taskSchedulingId })
    }
    
    
    /// Removes all task schedulings.
    ///
    mutating func clear() {
        
        self.taskSchedulings.removeAll()
    }
    
    
    /// Moves a task scheduling to a new date.
    ///
    /// The duration of the task is not changed, only its start date.
    ///
    /// - Returns:a `TaskScheduling` object that represents the new scheduling of the task.
    ///
    mutating func move(taskSchedulingWithId taskSchedulingId: UUID, toNewStartDate newStartDate: Date) throws -> TaskScheduling {
        
        guard let index = self.taskSchedulings.firstIndex(where: { $0.id == taskSchedulingId }) else { throw PlanningError.objectNotFound(id: taskSchedulingId) }
        
        self.taskSchedulings[index].timeSlot.startDate = newStartDate
        
        return self.taskSchedulings[index]
    }
    
    
    /// Returns all task schedulings whose time slot intersect with a given time slot.
    ///
    /// See `TimeSlot` for details about time slots intersections.
    ///
    /// - Parameter timeSlot: if `nil`, all task schedulings are returned.
    ///
    func taskSchedulings(intersectingWith timeSlot: TimeSlot? = nil) -> [TaskScheduling] {
        
        if let timeSlot = timeSlot {
            return self.taskSchedulings.filter { $0.timeSlot.intersects(with: timeSlot) }
        } else {
            return self.taskSchedulings
        }
    }
    
    
    /// Returns the scheduling for a given task whose start date is the latest, optionally restricting the search in a given time slot.
    ///
    /// - Returns: the `TaskScheduling` object, or `nil` if no scheduling for the task was found.
    ///
    func latestSchedulingByStartDate(forTaskWithId taskId: UUID, in timeSlot: TimeSlot? = nil) -> TaskScheduling? {
        
        return self.taskSchedulings(intersectingWith: timeSlot)
            .sortedByStartDate
            .last(where: { $0.task.id == taskId })
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
                var taskTimeSlot = TimeSlot(withStartDate: referenceDate, duration: taskDuration)!
                
                while true {
                    let existingSchedulings = self.taskSchedulings(intersectingWith: taskTimeSlot)
                    if !existingSchedulings.isEmpty {
                        taskTimeSlot.startDate = existingSchedulings.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })!.timeSlot.endDate
                    } else {
                        break
                    }
                }
                
                let taskScheduling = self.schedule(task, on: taskTimeSlot)
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
        
        self.fill(on: TimeSlot(between: slotStartDate, and: slotEndDate)!, using: backlog)
    }
}



enum PlanningError: Swift.Error {
    
    
    /// Indicates that an object with the given id could not be found when it was expected to.
    ///
    case objectNotFound(id: UUID)
}
