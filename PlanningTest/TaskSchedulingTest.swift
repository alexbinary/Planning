
import XCTest
@testable import Planning



class TaskSchedulingTest: XCTestCase {

    
    func test_init() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        
        XCTAssertEqual(scheduling.task, task)
        XCTAssertEqual(scheduling.timeSlot, timeSlot)
    }
    
    
    func test_equatable() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2)
        
        let scheduling1 = TaskScheduling(scheduling: task, on: timeSlot)
        let scheduling2 = TaskScheduling(scheduling: task, on: timeSlot)
        var scheduling3 = scheduling1
        scheduling3.feedback = .taskCompletedWithoutProblem
        
        XCTAssertNotEqual(scheduling1, scheduling2)
        XCTAssertEqual(scheduling1, scheduling3)
    }
}