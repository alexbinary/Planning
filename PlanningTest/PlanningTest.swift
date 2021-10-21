
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_taskSchedulingsOrderedByStartDateOldestFirst() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 6.hours, duration: 2.hours))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst, [ scheduling2, scheduling1, scheduling3 ])
    }
    
    
    func test_mostRecentTaskSchedulingEndDate_empty() {
        
        let planning = Planning(taskSchedulings: [ ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, nil)
    }
    
    
    func test_mostRecentTaskSchedulingEndDate_continuous() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling3.timeSlot.endDate)
    }
    
    
    func test_mostRecentTaskSchedulingEndDate_break() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 10.hours, duration: 2.hours))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling3.timeSlot.endDate)
    }
    
    
    func test_mostRecentTaskSchedulingEndDate_crossed() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 5.hours))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling2.timeSlot.endDate)
    }
    
    
    func test_moveTaskSchedulingToNewStartDate() {
 
        var planning = Planning(taskSchedulings: [])
        
        let duration = 2.hours
        let scheduling = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: duration))
        
        let newStartDate = .referenceDate + 4.hours
        let newTaskScheduling = planning.move(taskSchedulingWithId: scheduling.id, toNewStartDate: newStartDate)
        
        XCTAssertEqual(newTaskScheduling.timeSlot.startDate, newStartDate)
        XCTAssertEqual(newTaskScheduling.timeSlot.duration, duration)
    }
    
    
    func test_taskSchedulingsIn() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        let scheduling3 = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 6.hours, duration: 2.hours))
        
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate, and: .referenceDate + 10.hours)), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate + 3.hours, and: .referenceDate + 7.hours)), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(planning.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate + 4.hours + 30.minutes, and: .referenceDate + 5.hours + 30.minutes)), [scheduling2])
        XCTAssertEqual(planning.taskSchedulings(), [scheduling1, scheduling2, scheduling3])
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allPositive() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        planning.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        planning.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling2.id)
        planning.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allNegative() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        planning.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling1.id)
        planning.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        planning.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 0)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        _ = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        planning.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        planning.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 1/3)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed_slotSmaller() {
 
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        
        planning.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        planning.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)), 1)
        XCTAssertEqual(planning.feedbackScore(on: TimeSlot(between: .referenceDate + 2.hours + 30.minutes, and: .referenceDate + 3.hours)), 0)
    }
    
    
    func test_fillOnUsing_taskScheduledAfterSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        
        _ = planning.schedule(task1, on: TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration!))
        planning.fill(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration!), using: backlog)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst.count, 3)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].timeSlot, TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration!))
    }
    
    
    func test_fillOnUsing_taskScheduledInsideSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))
        
        _ = planning.schedule(task1, on: TimeSlot(withStartDate: .referenceDate + 20.minutes, duration: task1.referenceDuration!))
        planning.fill(on: TimeSlot(between: .referenceDate, and: .referenceDate + 80.minutes), using: backlog)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst.count, 4)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].timeSlot, TimeSlot(withStartDate: .referenceDate + 20.minutes, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].task, task2)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].timeSlot, TimeSlot(withStartDate: .referenceDate + 20.minutes + task1.referenceDuration!, duration: task2.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[3].task, task3)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[3].timeSlot, TimeSlot(withStartDate: .referenceDate + 20.minutes + task1.referenceDuration! + task2.referenceDuration!, duration: task3.referenceDuration!))
    }
    
    
    func test_fillOnUsing_backlogBiggerThanSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        _ = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))
        
        planning.fill(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration!), using: backlog)

        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst.count, 2)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
    }
    
    
    func test_fillOnUsing_backlogSameSizeThanSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))
        
        planning.fill(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration!), using: backlog)

        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst.count, 3)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].task, task3)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration!, duration: task3.referenceDuration!))
    }
    
    
    func test_fillOnUsing_backlogSmallerThanSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        let task1 = backlog.add(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = backlog.add(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = backlog.add(Task(withName: "t3", referenceDuration: 30.minutes))
        
        planning.fill(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration! + task1.referenceDuration!), using: backlog)

        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst.count, 4)
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[0].timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].task, task2)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[1].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration!, duration: task2.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].task, task3)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[2].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration!, duration: task3.referenceDuration!))
        
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[3].task, task1)
        XCTAssertEqual(planning.taskSchedulingsOrderedByStartDateOldestFirst[3].timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration! + task2.referenceDuration! + task3.referenceDuration!, duration: task1.referenceDuration!))
    }
}
