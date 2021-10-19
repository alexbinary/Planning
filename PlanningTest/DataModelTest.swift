
import XCTest
@testable import Planning



class DataModelTest: XCTestCase {

    
    func test_fillPlanningFromTo_backlogBiggerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1"))
        let task2 = dataModel.addToBacklog(Task(withName: "t2"))
        _ = dataModel.addToBacklog(Task(withName: "t3"))
        
        dataModel.fillPlanning(from: Date(timeIntervalSinceReferenceDate: 0), to: Date(timeIntervalSinceReferenceDate: 45*60))
        
        XCTAssertEqual(dataModel.planning.entries.count, 2)
        XCTAssertEqual(dataModel.planning.entries[0].task, task1)
        XCTAssertEqual(dataModel.planning.entries[1].task, task2)
    }
    
    
    func test_fillPlanningFromTo_backlogSameSizeThanSlot() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1"))
        let task2 = dataModel.addToBacklog(Task(withName: "t2"))
        let task3 = dataModel.addToBacklog(Task(withName: "t3"))
        
        dataModel.fillPlanning(from: Date(timeIntervalSinceReferenceDate: 0), to: Date(timeIntervalSinceReferenceDate: 80*60))
        
        XCTAssertEqual(dataModel.planning.entries.count, 3)
        XCTAssertEqual(dataModel.planning.entries[0].task, task1)
        XCTAssertEqual(dataModel.planning.entries[1].task, task2)
        XCTAssertEqual(dataModel.planning.entries[2].task, task3)
    }
    
    
    func test_fillPlanningFromTo_backlogSmallerThanSlot() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let task1 = dataModel.addToBacklog(Task(withName: "t1"))
        let task2 = dataModel.addToBacklog(Task(withName: "t2"))
        let task3 = dataModel.addToBacklog(Task(withName: "t3"))
        
        dataModel.fillPlanning(from: Date(timeIntervalSinceReferenceDate: 0), to: Date(timeIntervalSinceReferenceDate: 110*60))
        
        XCTAssertEqual(dataModel.planning.entries.count, 4)
        XCTAssertEqual(dataModel.planning.entries[0].task, task1)
        XCTAssertEqual(dataModel.planning.entries[1].task, task2)
        XCTAssertEqual(dataModel.planning.entries[2].task, task3)
        XCTAssertEqual(dataModel.planning.entries[3].task, task1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allPositive() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let entry3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onPlanningEntryWithId: entry1.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onPlanningEntryWithId: entry2.id)
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onPlanningEntryWithId: entry3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 6)), 1)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_allNegative() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let entry3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onPlanningEntryWithId: entry1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onPlanningEntryWithId: entry2.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onPlanningEntryWithId: entry3.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 6)), 0)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        _ = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onPlanningEntryWithId: entry1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onPlanningEntryWithId: entry2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 6)), 1/3)
    }
    
    
    func test_planningFeedbackScoreBetweenAnd_mixed_slotSmaller() {
 
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        dataModel.giveFeedback(.taskCompletedWithoutProblem, onPlanningEntryWithId: entry1.id)
        dataModel.giveFeedback(.taskCouldNotBeDoneCorrectlyOrDoneAtAll, onPlanningEntryWithId: entry2.id)
        
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 1)), 1)
        XCTAssertEqual(dataModel.planningFeedbackScore(on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 2)), 0)
    }
}
