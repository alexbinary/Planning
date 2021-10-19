
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_mostRecentEntryEndDate_empty() {
        
        let planning = Planning(entries: [ ])
        
        XCTAssertEqual(planning.mostRecentEntryEndDate, nil)
    }
    
    func test_mostRecentEntryEndDate_continuous() {
        
        let entry1 = PlanningEntry(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let entry2 = PlanningEntry(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 2)
        let entry3 = PlanningEntry(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 4), duration: 2)
        
        let planning = Planning(entries: [ entry1, entry2, entry3 ])
        
        XCTAssertEqual(planning.mostRecentEntryEndDate, entry3.endDate)
    }
    
    func test_mostRecentEntryEndDate_break() {
        
        let entry1 = PlanningEntry(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let entry2 = PlanningEntry(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 2)
        let entry3 = PlanningEntry(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 10), duration: 2)
        
        let planning = Planning(entries: [ entry1, entry2, entry3 ])
        
        XCTAssertEqual(planning.mostRecentEntryEndDate, entry3.endDate)
    }
    
    func test_mostRecentEntryEndDate_crossed() {
        
        let entry1 = PlanningEntry(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let entry2 = PlanningEntry(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 5)
        let entry3 = PlanningEntry(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 4), duration: 2)
        
        let planning = Planning(entries: [ entry1, entry2, entry3 ])
        
        XCTAssertEqual(planning.mostRecentEntryEndDate, entry2.endDate)
    }
}
