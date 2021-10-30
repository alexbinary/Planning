
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_taskSchedulingsIntersectingWith() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1"), on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        let scheduling2 = planning.schedule(Task(withName: "t2"), on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        let scheduling3 = planning.schedule(Task(withName: "t3"), on: TimeSlot(between: .referenceDate + 6.hours, and: .referenceDate + 8.hours)!)
        
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(
                                                    between: .referenceDate,
                                                    and: .referenceDate + 10.hours)
        ), [scheduling1, scheduling2, scheduling3])
        
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(
                                                    between: .referenceDate + 3.hours,
                                                    and: .referenceDate + 7.hours)
        ), [scheduling1, scheduling2, scheduling3])
        
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(
                                                    between: .referenceDate + 4.hours + 30.minutes,
                                                    and: .referenceDate + 5.hours + 30.minutes)
        ), [scheduling2])
        
        XCTAssertEqual(planning.taskSchedulings(), [scheduling1, scheduling2, scheduling3])
    }
    
    
    func test_latestSchedulingByStartDateForTaskWithId() {
     
        var planning = Planning(taskSchedulings: [])
        
        let task1 = Task(withName: "t1")
        let task2 = Task(withName: "t2")
        
        planning.schedule(task1, on: TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
        planning.schedule(task2, on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        planning.schedule(task1, on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        
        let latestSchedulingForTask1 = planning.latestSchedulingByStartDate(forTaskWithId: task1.id)
        
        XCTAssertNotNil(latestSchedulingForTask1)
        XCTAssertEqual(latestSchedulingForTask1!.timeSlot, TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
    }
    
    
    func test_latestSchedulingByStartDateForTaskWithId_noMatch() {
     
        var planning = Planning(taskSchedulings: [])
        
        let task1 = Task(withName: "t1")
        let task2 = Task(withName: "t2")
        let task3 = Task(withName: "t3")
        
        planning.schedule(task1, on: TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
        planning.schedule(task2, on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        planning.schedule(task1, on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        
        let latestSchedulingForTask3 = planning.latestSchedulingByStartDate(forTaskWithId: task3.id)
        
        XCTAssertNil(latestSchedulingForTask3)
    }
    
    
    func test_latestSchedulingByStartDateForTaskWithIdIn() {
     
        var planning = Planning(taskSchedulings: [])
        
        let task1 = Task(withName: "t1")
        let task2 = Task(withName: "t2")
        
        planning.schedule(task1, on: TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
        planning.schedule(task2, on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        planning.schedule(task1, on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        
        let latestSchedulingForTask1 = planning.latestSchedulingByStartDate(forTaskWithId: task1.id, in: TimeSlot(between: .referenceDate, and: .referenceDate + 3.hours)!)
        
        XCTAssertNotNil(latestSchedulingForTask1)
        XCTAssertEqual(latestSchedulingForTask1!.timeSlot, TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
    }
    
    
    func test_latestSchedulingByStartDateForTaskWithIdIn_noMatch() {
     
        var planning = Planning(taskSchedulings: [])
        
        let task1 = Task(withName: "t1")
        let task2 = Task(withName: "t2")
        
        planning.schedule(task1, on: TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
        planning.schedule(task2, on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        planning.schedule(task2, on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        
        let latestSchedulingForTask1 = planning.latestSchedulingByStartDate(forTaskWithId: task1.id, in: TimeSlot(between: .referenceDate + 3.hours, and: .referenceDate + 6.hours)!)
        
        XCTAssertNil(latestSchedulingForTask1)
    }
    
    
    func test_scheduleTaskOn() {
 
        var planning = Planning(taskSchedulings: [])
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!
        
        let scheduling = planning.schedule(task, on: timeSlot)
        
        XCTAssertEqual(planning.taskSchedulings, [ scheduling ])
        
        XCTAssertEqual(scheduling.task, task)
        XCTAssertEqual(scheduling.timeSlot, timeSlot)
        XCTAssertEqual(scheduling.feedback, nil)
    }
    
    
    /// Asserts that when there is no conflict the task is scheduled on the suggested time slot,
    /// and the scheduling that was added is returned, and that it is in a default state.
    ///
    func test_tryScheduleTaskOn_noConflict() throws {
 
        var planning = Planning(taskSchedulings: [])
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!
        
        let scheduling = try planning.trySchedule(task, on: timeSlot)
        
        XCTAssertEqual(planning.taskSchedulings, [ scheduling ])
        
        XCTAssertEqual(scheduling.task, task)
        XCTAssertEqual(scheduling.timeSlot, timeSlot)
        XCTAssertEqual(scheduling.feedback, nil)
    }
    
    
    /// Asserts that in case there is already a task scheduled on a time slot that conflicts with the suggested time slot,
    /// and if the task does not allow squeezing, the task is scheduled right after the conflicting task.
    ///
    func test_tryScheduleTaskOn_conflictLeavingSpaceBefore_taskDisallowsSqueezing() {
 
        var planning = Planning(taskSchedulings: [])
        
        let preScheduledTask = Task(withName: "preScheduledTask")

        try! planning.trySchedule(preScheduledTask, on: TimeSlot(
            between: .referenceDate + 25.minutes,
                and: .referenceDate + 35.minutes
        )!)
        
        let candidateTask = Task(withName: "candidateTask")

        XCTAssertNoThrow(try planning.trySchedule(candidateTask, on: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 30.minutes
        )!))

        // Expected result :
        //
        // T + 0        -
        // T + 25 min   - pre scheduled task
        // T + 35 min   - candidate task
        // T + 65 min   -

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 2)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, preScheduledTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, candidateTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 35.minutes,
                            and: .referenceDate + 65.minutes
        ))
    }
    
    
    /// Asserts that in case there is already a task scheduled on a time slot that conflicts with the suggested time slot,
    /// and if the task allows squeezing but the free space is too short, the task is scheduled right after the conflicting task.
    ///
    func test_tryScheduleTaskOn_conflictLeavingSpaceBefore_taskCannotBeSqueezedEnough() {
 
        var planning = Planning(taskSchedulings: [])
        
        let preScheduledTask = Task(withName: "preScheduledTask")

        try! planning.trySchedule(preScheduledTask, on: TimeSlot(
            between: .referenceDate + 25.minutes,
                and: .referenceDate + 35.minutes
        )!)
        
        let candidateTask = Task(withName: "candidateTask", minimumDuration: 26.minutes)

        XCTAssertNoThrow(try planning.trySchedule(candidateTask, on: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 30.minutes
        )!))

        // Expected result :
        //
        // T + 0        -
        // T + 25 min   - pre scheduled task
        // T + 35 min   - candidate task
        // T + 65 min   -

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 2)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, preScheduledTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, candidateTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 35.minutes,
                            and: .referenceDate + 65.minutes
        ))
    }
    
    
    /// Asserts that in case there is already a task scheduled on a time slot that conflicts with the suggested time slot,
    /// and if the task allows squeezing and the free space is long enough, the task is scheduled just before the conflicting task.
    ///
    func test_tryScheduleTaskOn_conflictLeavingSpaceBefore_taskCanBeSqueezedBefore() {
 
        var planning = Planning(taskSchedulings: [])
        
        let preScheduledTask = Task(withName: "preScheduledTask")

        try! planning.trySchedule(preScheduledTask, on: TimeSlot(
            between: .referenceDate + 25.minutes,
                and: .referenceDate + 35.minutes
        )!)
        
        let candidateTask = Task(withName: "candidateTask", minimumDuration: 20.minutes)

        XCTAssertNoThrow(try planning.trySchedule(candidateTask, on: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 30.minutes
        )!))

        // Expected result :
        //
        // T + 0        - candidate task
        // T + 25 min   - pre scheduled task
        // T + 35 min   -

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 2)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, candidateTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 0.minutes,
                            and: .referenceDate + 25.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, preScheduledTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
    }
    
    
    /// Asserts that in case there is already multiple tasks scheduled on adjacent time slots such that at least one of them conflicts with the suggested time slot,
    /// and if the task does not allow squeezing, the task is scheduled right after the last conflicting task.
    ///
    func test_tryScheduleTaskOn_conflict_multipleAdjacentTasks() {
 
        var planning = Planning(taskSchedulings: [])
        
        let preScheduledTask1 = Task(withName: "preScheduledTask1")
        let preScheduledTask2 = Task(withName: "preScheduledTask2")

        try! planning.trySchedule(preScheduledTask1, on: TimeSlot(
            between: .referenceDate + 25.minutes,
                and: .referenceDate + 35.minutes
        )!)
        try! planning.trySchedule(preScheduledTask2, on: TimeSlot(
            between: .referenceDate + 35.minutes,
                and: .referenceDate + 65.minutes
        )!)
        
        let candidateTask = Task(withName: "candidateTask")

        XCTAssertNoThrow(try planning.trySchedule(candidateTask, on: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 30.minutes
        )!))

        // Expected result :
        //
        // T + 0        -
        // T + 25 min   - pre scheduled task 1
        // T + 35 min   - pre scheduled task 2
        // T + 65 min   - candidate task
        // T + 95 min   -

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 3)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, preScheduledTask1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, preScheduledTask2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 35.minutes,
                            and: .referenceDate + 65.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].task, candidateTask)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].timeSlot, TimeSlot(
                        between: .referenceDate + 65.minutes,
                            and: .referenceDate + 95.minutes
        ))
    }
    
    
    /// Asserts that scheduling fails if the task cannot be scheduled inside a restricting time slot.
    ///
    func test_tryScheduleTaskOn_failure_task() {
 
        var planning = Planning(taskSchedulings: [])
        
        let preScheduledTask = Task(withName: "preScheduledTask1")

        try! planning.trySchedule(preScheduledTask, on: TimeSlot(
            between: .referenceDate + 20.minutes,
                and: .referenceDate + 50.minutes
        )!)
        
        let candidateTask = Task(withName: "candidateTask")

        XCTAssertThrowsError(try planning.trySchedule(candidateTask, on: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 30.minutes
        )!, restrictingSchedulingOptionsInside: TimeSlot(
            between: .referenceDate + 0.minutes,
                and: .referenceDate + 45.minutes
        )!))

        // Expected result if wouldn't have failed:
        //
        // T + 0        -
        // T + 25 min   - pre scheduled task
        // T + 35 min   - candidate task
        // T + 65 min   -
    }
    
    
    func test_moveTaskSchedulingToNewStartDate() throws {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling = planning.schedule(Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
        let newStartDate = .referenceDate + 4.hours
        let newTaskScheduling = try planning.move(taskSchedulingWithId: scheduling.id, toNewStartDate: newStartDate)
        
        XCTAssertEqual(planning.taskSchedulings, [ newTaskScheduling ])
        
        XCTAssertEqual(newTaskScheduling.task, scheduling.task)
        XCTAssertEqual(newTaskScheduling.timeSlot.startDate, newStartDate)
        XCTAssertEqual(newTaskScheduling.timeSlot.duration, scheduling.timeSlot.duration)
        XCTAssertEqual(newTaskScheduling.feedback, scheduling.feedback)
    }
    
    
    func test_moveTaskSchedulingToNewStartDate_notFound() {
 
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
        var planning = Planning(taskSchedulings: [ scheduling1 ])
        
        XCTAssertThrowsError(try planning.move(taskSchedulingWithId: scheduling2.id, toNewStartDate: .referenceDate))
    }
    
    
    func test_feedbackScoreOn() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1"), on: TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!)
        let scheduling2 = planning.schedule(Task(withName: "t2"), on: TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!)
        planning.schedule(Task(withName: "t3"), on: TimeSlot(between: .referenceDate + 4.hours, and: .referenceDate + 6.hours)!)
        
        try! planning.setFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        try! planning.setFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)!), 1/3)
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)!), 1)
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate + 2.hours + 30.minutes, and: .referenceDate + 3.hours)!), 0)
    }
    
    
    func test_setFeedbackOnTaskSchedulingWithId() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling = planning.schedule(Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        
        let feedback: TaskSchedulingFeedback = .taskCompletedWithoutProblem

        XCTAssertNoThrow(try planning.setFeedback(feedback, onTaskSchedulingWithId: scheduling.id))
        
        XCTAssertEqual(planning.taskSchedulings[0].feedback, feedback)
    }
    
    
    func test_setFeedbackOnTaskSchedulingWithId_notFound() {
 
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        
        var planning = Planning(taskSchedulings: [ scheduling1 ])
        
        XCTAssertThrowsError(try planning.setFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling2.id))
    }
    
    
    func test_deleteTaskSchedulingWithId() {
 
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        
        var planning = Planning(taskSchedulings: [ scheduling1, scheduling2 ])
        
        XCTAssertNoThrow(try planning.delete(taskSchedulingWithId: scheduling1.id))
        
        XCTAssertEqual(planning.taskSchedulings, [ scheduling2 ])
    }
    
    
    func test_deleteTaskSchedulingWithId_notFound() {
 
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!)
        
        var planning = Planning(taskSchedulings: [ scheduling1, scheduling2 ])
        
        XCTAssertThrowsError(try planning.delete(taskSchedulingWithId: scheduling3.id))
    }
    
    
    func test_clear() {
 
        var planning = Planning(taskSchedulings: [
            TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours)!),
            TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        ])
        
        planning.clear()
        
        XCTAssertEqual(planning.taskSchedulings, [])
    }
}
