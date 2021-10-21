
import XCTest
@testable import Planning



class DataModelTest: XCTestCase {

    
    func test_fillPlanningOn_taskScheduledAfterSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 20.minutes))
        
        _ = dataModel.addToPlanning(task1, on: TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration))
        dataModel.fillPlanning(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration + task2.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .count, 2)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task2.id } .count, 1)
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .min(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })! .timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .max(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })! .timeSlot, TimeSlot(withStartDate: .referenceDate + 1.hours, duration: task1.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task2.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration, duration: task2.referenceDuration))
    }
    
    
    func test_fillPlanningOn_backlogBiggerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration + task2.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .count, 1)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task2.id } .count, 1)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task3.id } .count, 0)
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task1.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task2.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration, duration: task2.referenceDuration))
    }
    
    
    func test_fillPlanningOn_backlogSameSizeThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration + task2.referenceDuration + task3.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .count, 1)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task2.id } .count, 1)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task3.id } .count, 1)
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task1.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task2.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration, duration: task2.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task3.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration + task2.referenceDuration, duration: task3.referenceDuration))
    }
    
    
    func test_fillPlanningOn_backlogSmallerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1", referenceDuration: 10.minutes))
        let task2 = dataModel.addToBacklog(Task(withName: "t2", referenceDuration: 20.minutes))
        let task3 = dataModel.addToBacklog(Task(withName: "t3", referenceDuration: 30.minutes))
        
        dataModel.fillPlanning(on: TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration + task2.referenceDuration + task3.referenceDuration + task1.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .count, 2)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task2.id } .count, 1)
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task3.id } .count, 1)
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .min(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })! .timeSlot, TimeSlot(withStartDate: .referenceDate, duration: task1.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.filter { $0.task.id == task1.id } .max(by: { $0.timeSlot.startDate < $1.timeSlot.startDate })! .timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration + task2.referenceDuration + task3.referenceDuration, duration: task1.referenceDuration))
        
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task2.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration, duration: task2.referenceDuration))
        XCTAssertEqual(dataModel.planning.taskSchedulings.first(where: { $0.task.id == task3.id })!.timeSlot, TimeSlot(withStartDate: .referenceDate + task1.referenceDuration + task2.referenceDuration, duration: task3.referenceDuration))        
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allPositive() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling2.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allNegative() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 0)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        _ = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 6.hours)), 1/3)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed_slotSmaller() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate, duration: 2.hours))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onTaskSchedulingWithId: scheduling1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onTaskSchedulingWithId: scheduling2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)), 1)
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(between: .referenceDate + 2.hours + 30.minutes, and: .referenceDate + 3.hours)), 0)
    }
    
    
    func test_taskSchedulingsIn() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 6.hours, duration: 2.hours))
        
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate, and: .referenceDate + 10.hours)), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate + 3.hours, and: .referenceDate + 7.hours)), [scheduling1, scheduling2, scheduling3])
        XCTAssertEqual(dataModel.taskSchedulings(intersectingWith: TimeSlot(between: .referenceDate + 4.hours + 30.minutes, and: .referenceDate + 5.hours + 30.minutes)), [scheduling2])
        XCTAssertEqual(dataModel.taskSchedulings(), [scheduling1, scheduling2, scheduling3])
    }
    
    
    func test_moveTaskSchedulingToNewStartDate() {
 
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let duration = 2.hours
        let scheduling = dataModel.addToPlanning(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: duration))
        
        let newStartDate = .referenceDate + 4.hours
        let newTaskScheduling = dataModel.move(taskSchedulingWithId: scheduling.id, toNewStartDate: newStartDate)
        
        XCTAssertEqual(newTaskScheduling.timeSlot.startDate, newStartDate)
        XCTAssertEqual(newTaskScheduling.timeSlot.duration, duration)
    }
}
