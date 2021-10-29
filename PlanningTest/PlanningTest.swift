
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
