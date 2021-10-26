
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_taskSchedulingsSortedByStartDate() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours)!)
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 6.hours, duration: 2.hours)!)
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate, [ scheduling2, scheduling1, scheduling3 ])
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
    
    
    func test_moveTaskSchedulingToNewStartDate() throws {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
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
    
    
    func test_scheduleTasksOnUsing_taskScheduledAfterSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        
        planning.schedule(task1, on: TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration!)!)
        planning.scheduleTasks(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration!)!, using: backlog)
        
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate.count, 3)
        
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].timeSlot, TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration!))
    }
    
    
    func test_scheduleTasksOnUsing_tasksScheduledInsideSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        // manually scheduled tasks

        let preScheduledTask1 = Task(withName: "preScheduledTask1")
        let preScheduledTask2 = Task(withName: "preScheduledTask2")

        planning.schedule(preScheduledTask1, on: TimeSlot(
                                between: .referenceDate + 25.minutes,
                                    and: .referenceDate + 35.minutes
        )!)
        planning.schedule(preScheduledTask2, on: TimeSlot(
                                between: .referenceDate + 35.minutes,
                                    and: .referenceDate + 45.minutes
        )!)

        // auto filling from backlog

        let backlogTask1 = Task(withName: "backlogTask1", referenceDuration: 10.minutes)
        let backlogTask2 = Task(withName: "backlogTask2", referenceDuration: 20.minutes)
        let backlogTask3 = Task(withName: "backlogTask3", referenceDuration: 30.minutes)

        _ = backlog.add(backlogTask1)
        _ = backlog.add(backlogTask2)
        _ = backlog.add(backlogTask3)

        planning.scheduleTasks(on: TimeSlot(
            between: .referenceDate + 0.minutes,
            and: .referenceDate + 95.minutes
        )!, using: backlog)

        // Expected result :
        //
        // T + 0        - task1
        // T + 10 min
        // T + 25 min   - pre scheduled task 1
        // T + 35 min   - pre scheduled task 2
        // T + 45 min   - task 2
        // T + 65 min   - task 3
        // T + 95 min

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate.count, 5)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].task, backlogTask1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 0.minutes,
                            and: .referenceDate + 10.minutes
        ))
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].task, preScheduledTask1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].task, preScheduledTask2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].timeSlot, TimeSlot(
                        between: .referenceDate + 35.minutes,
                            and: .referenceDate + 45.minutes
        ))
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[3].task, backlogTask2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[3].timeSlot, TimeSlot(
                        between: .referenceDate + 45.minutes,
                            and: .referenceDate + 65.minutes
        ))
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[4].task, backlogTask3)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[4].timeSlot, TimeSlot(
                        between: .referenceDate + 65.minutes,
                            and: .referenceDate + 95.minutes
        ))
    }
    
    
    func test_scheduleTasksOnUsing_backlogBiggerThanSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        _ = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))

        planning.scheduleTasks(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration!)!, using: backlog)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate.count, 2)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
    }
    
    
    func test_scheduleTasksOnUsing_backlogSameSizeThanSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))

        planning.scheduleTasks(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration!)!, using: backlog)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate.count, 3)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].task, task3)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration!, duration: task3.referenceDuration!))
    }
    
    
    func test_scheduleTasksOnUsing_backlogSmallerThanSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))

        planning.scheduleTasks(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration! + task1.referenceDuration!)!, using: backlog)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate.count, 4)

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].task, task3)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[2].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration!, duration: task3.referenceDuration!))

        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[3].task, task1)
        XCTAssertEqual(planning.taskSchedulingsSortedByStartDate[3].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration!, duration: task1.referenceDuration!))
    }
}
