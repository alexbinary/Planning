
import Foundation



/// A type that represents a planning.
///
/// A planning positionnes tasks and other pieces of information on time slots.
///
struct Planning: Codable
{
    
    // MARK: - Reading task schedulings
    
    
    /// The tasks schedulings that the planning stores.
    ///
    var taskSchedulings: [TaskScheduling]
    
    
    
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
    
    
    // MARK: - Schedulings tasks
    
    
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
    
    
    /// Schedules tasks on a given time slots using a given backlog.
    ///
    mutating func scheduleTasks(on timeSlot: TimeSlot, using backlog: Backlog) {
        
        var referenceDate = timeSlot.startDate
        
        while true {
            for task in backlog.tasks {
                
                guard referenceDate < timeSlot.endDate else {
                    return
                }
                
                let taskDuration = task.referenceDuration ?? 30.minutes
                var proposedTimeSlotForTask = TimeSlot(withStartDate: referenceDate, duration: taskDuration)!
                
                while true {
                
                    // check if tasks are already scheduled on time slots that conflict with the proposed time slot
                    
                    let intersectingSchedulings = self.taskSchedulings(intersectingWith: proposedTimeSlotForTask)
                    if intersectingSchedulings.isEmpty {
                        
                        break   // no conflict, task can be scheduled on proposed time slot
                    }
                    
                    // from here, there is a scheduling conflict
                    
                    // attempt to squeeze the task before the first conflicting task
                    
                    if let taskMinimumDuration = task.minimumDuration {
                        
                        let earliestIntersectingScheduling = intersectingSchedulings.min(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })!
                        let durationToEarliestIntersectingScheduling = proposedTimeSlotForTask.startDate.distance(to: earliestIntersectingScheduling.timeSlot.startDate)
                        if durationToEarliestIntersectingScheduling > taskMinimumDuration {
                            
                            proposedTimeSlotForTask.duration = durationToEarliestIntersectingScheduling
                            break
                        }
                    }
                    
                    // attempt to schedule task after the latest conflicting slot
                    
                    proposedTimeSlotForTask.startDate = intersectingSchedulings.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })!.timeSlot.endDate
                    
                    continue    // redo all the checking above for the new proposed slot
                }
                
                if proposedTimeSlotForTask.startDate >= timeSlot.endDate {
                    
                    return
                }
                
                // reduce the duration of the task so that it does not spill outside the allocated time slot
                
                if proposedTimeSlotForTask.endDate >= timeSlot.endDate {
                
                    if let taskMinimumDuration = task.minimumDuration {
                        
                        let durationToSlotEnd = proposedTimeSlotForTask.startDate.distance(to: timeSlot.endDate)
                        if durationToSlotEnd > taskMinimumDuration {
                            
                            proposedTimeSlotForTask.duration = durationToSlotEnd
                        }
                    }
                }
                
                // schedule task
                
                let taskScheduling = self.schedule(task, on: proposedTimeSlotForTask)
                if taskScheduling.timeSlot.endDate >= timeSlot.endDate {
                    
                    return  // quit if end of slot is reached
                }
                
                referenceDate = taskScheduling.timeSlot.endDate
                continue    // proceed to scheduling of next task
            }
        }
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
    
    
    // MARK: - Feedback
    
    
    /// Returns the feedback score of the planning in a given time slot.
    ///
    func feedbackScore(on timeSlot: TimeSlot) -> Float {
        
        let taskSchedulingsInSlot = self.taskSchedulings(intersectingWith: timeSlot)
        
        return Float(taskSchedulingsInSlot.filter { $0.feedback == .taskCompletedWithoutProblem } .count) / Float(taskSchedulingsInSlot.count)
    }
    
    
    /// Sets a feedback on a task scheduling.
    ///
    mutating func setFeedback(_ feedback: TaskSchedulingFeedback, onTaskSchedulingWithId taskSchedulingId: UUID) throws {
        
        guard let index = self.taskSchedulings.firstIndex(where: { $0.id == taskSchedulingId }) else { throw PlanningError.objectNotFound(id: taskSchedulingId) }
        
        self.taskSchedulings[index].feedback = feedback
    }
    
    
    // MARK: - Removing schedulings
    
    
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
}



enum PlanningError: Swift.Error {
    
    
    /// Indicates that an object with the given id could not be found when it was expected to.
    ///
    case objectNotFound(id: UUID)
}
