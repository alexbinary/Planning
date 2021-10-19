
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_mostRecentItemEndDate_empty() {
        
        let planning = Planning(items: [ ])
        
        XCTAssertEqual(planning.mostRecentItemEndDate, nil)
    }
    
    func test_mostRecentItemEndDate_continuous() {
        
        let item1 = PlanningItem(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let item2 = PlanningItem(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 2)
        let item3 = PlanningItem(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 4), duration: 2)
        
        let planning = Planning(items: [ item1, item2, item3 ])
        
        XCTAssertEqual(planning.mostRecentItemEndDate, item3.endDate)
    }
    
    func test_mostRecentItemEndDate_break() {
        
        let item1 = PlanningItem(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let item2 = PlanningItem(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 2)
        let item3 = PlanningItem(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 10), duration: 2)
        
        let planning = Planning(items: [ item1, item2, item3 ])
        
        XCTAssertEqual(planning.mostRecentItemEndDate, item3.endDate)
    }
    
    func test_mostRecentItemEndDate_crossed() {
        
        let item1 = PlanningItem(withTask: Task(withName: "t1"), startingAt: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        let item2 = PlanningItem(withTask: Task(withName: "t2"), startingAt: Date(timeIntervalSinceReferenceDate: 2), duration: 5)
        let item3 = PlanningItem(withTask: Task(withName: "t3"), startingAt: Date(timeIntervalSinceReferenceDate: 4), duration: 2)
        
        let planning = Planning(items: [ item1, item2, item3 ])
        
        XCTAssertEqual(planning.mostRecentItemEndDate, item2.endDate)
    }
}
