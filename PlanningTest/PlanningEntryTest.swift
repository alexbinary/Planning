
import XCTest
@testable import Planning



class PlanningEntryTest: XCTestCase {

    
    func test_init() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        
        let entry = PlanningEntry(withTask: task, on: timeSlot)
        
        XCTAssertEqual(entry.task, task)
        XCTAssertEqual(entry.timeSlot, timeSlot)
    }
    
    
    func test_equatable() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        
        let entry1 = PlanningEntry(withTask: task, on: timeSlot)
        let entry2 = PlanningEntry(withTask: task, on: timeSlot)
        var entry3 = entry1
        entry3.feedback = .taskCompletedWithoutProblem
        
        XCTAssertNotEqual(entry1, entry2)
        XCTAssertEqual(entry1, entry3)
    }
}
