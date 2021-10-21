
import XCTest
@testable import Planning



class PlanningTest: XCTestCase {

    
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
}
