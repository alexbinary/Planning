
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
}
