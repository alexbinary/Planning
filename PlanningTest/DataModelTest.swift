
import XCTest
@testable import Planning



class DataModelTest: XCTestCase {

    
    func test_fillPlanningFromTo_backlogBiggerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 30.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 30.minutes))
        _ = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 45*60))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.count, 2)
        XCTAssertEqual(dataModel.planning.taskSchedulings[0].task, task1)
        XCTAssertEqual(dataModel.planning.taskSchedulings[1].task, task2)
    }
    
    
    func test_fillPlanningFromTo_backlogSameSizeThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 30.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 30.minutes))
        let task3 = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 80*60))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.count, 3)
        XCTAssertEqual(dataModel.planning.taskSchedulings[0].task, task1)
        XCTAssertEqual(dataModel.planning.taskSchedulings[1].task, task2)
        XCTAssertEqual(dataModel.planning.taskSchedulings[2].task, task3)
    }
    
    
    func test_fillPlanningFromTo_backlogSmallerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 30.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 30.minutes))
        let task3 = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 110*60))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.count, 4)
        XCTAssertEqual(dataModel.planning.taskSchedulings[0].task, task1)
        XCTAssertEqual(dataModel.planning.taskSchedulings[1].task, task2)
        XCTAssertEqual(dataModel.planning.taskSchedulings[2].task, task3)
        XCTAssertEqual(dataModel.planning.taskSchedulings[3].task, task1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allPositive() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling2.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 6))), 1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allNegative() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 6))), 0)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        _ = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 6))), 1/3)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed_slotSmaller() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0.0), and: Date(timeIntervalSinceReferenceDate: 1.0))), 1)
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 2.5), and: Date(timeIntervalSinceReferenceDate: 3.0))), 0)
    }
    
    
    func test_taskSchedulingsIn() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 6), duration: 2))
        
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0.0), and: Date(timeIntervalSinceReferenceDate: 10.0))), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 3.0), and: Date(timeIntervalSinceReferenceDate:  7.0))), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: Date(timeIntervalSinceReferenceDate: 4.5), and: Date(timeIntervalSinceReferenceDate:  5.5))), [scheduling2])
        XCTAssertEqual(dataModel.taskSchedulings(), [scheduling1, scheduling2, scheduling3])
    }
    
    
    func test_moveTaskSchedulingToNewStartDate() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let duration: TimeInterval = 2
        let scheduling = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: duration))
        
        let newStartDate = Date(timeIntervalSinceReferenceDate: 4)
        let newTaskScheduling = dataModel.move(taskSchedulingWithId: scheduling.id, toNewStartDate: newStartDate)
        
        XCTAssertEqual(newTaskScheduling.timeSlot.startDate, newStartDate)
        XCTAssertEqual(newTaskScheduling.timeSlot.duration, duration)
    }
}
