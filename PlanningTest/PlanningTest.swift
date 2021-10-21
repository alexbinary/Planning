
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
    func test_mostRecentTaskSchedulingEndDate_empty() {
        
        let planning = Planning(taskSchedulings: [ ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, nil)
    }
    
    func test_mostRecentTaskSchedulingEndDate_continuous() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling3.timeSlot.endDate)
    }
    
    func test_mostRecentTaskSchedulingEndDate_break() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 10), duration: 2))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling3.timeSlot.endDate)
    }
    
    func test_mostRecentTaskSchedulingEndDate_crossed() {
        
        let scheduling1 = TaskScheduling(scheduling: Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 0), duration: 2))
        let scheduling2 = TaskScheduling(scheduling: Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 5))
        let scheduling3 = TaskScheduling(scheduling: Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        
        let planning = Planning(taskSchedulings: [ scheduling1, scheduling2, scheduling3 ])
        
        XCTAssertEqual(planning.mostRecentTaskSchedulingEndDate, scheduling2.timeSlot.endDate)
    }
}
