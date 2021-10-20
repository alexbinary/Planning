
import XCTest
@testable import Planning



class TimeSlotTest: XCTestCase {

    
    func test_init_startDateDuration() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let duration: TimeInterval = 2
        
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertEqual(timeSlot.startDate, startDate)
        XCTAssertEqual(timeSlot.duration, duration)
    }
    
    
    func test_init_startDateEndDate() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let duration: TimeInterval = 2
        let endDate = startDate.addingTimeInterval(duration)
        
        let timeSlot = TimeSlot(between: startDate, and: endDate)
        
        XCTAssertEqual(timeSlot.startDate, startDate)
        XCTAssertEqual(timeSlot.duration, duration)
        XCTAssertEqual(timeSlot.endDate, endDate)
    }
    
    
    func test_endDate() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let duration: TimeInterval = 2
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertEqual(timeSlot.endDate, startDate.addingTimeInterval(duration))
    }
    
    
    func test_equatable() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let duration: TimeInterval = 2
        
        let timeSlot1 = TimeSlot(withStartDate: startDate, duration: duration)
        var timeSlot2 = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertEqual(timeSlot1, timeSlot2)
        
        timeSlot2.duration = 3
        
        XCTAssertNotEqual(timeSlot1, timeSlot2)
    }
    
    
    func test_intersection_noIntersection() {
        
        let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
        let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 2), and: Date(timeIntervalSinceReferenceDate: 3))
        
        let expectedIntersection: TimeSlot? = nil
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_oneContainsTheOther() {
        
        let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 3))
        let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 2))
        
        let expectedIntersection: TimeSlot? = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 2))
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_partialIntersection() {
        
        let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 2))
        let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 3))
        
        let expectedIntersection: TimeSlot? = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 2))
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_partialIntersection_slotWithDurationZero() {
        
        let timeSlot1 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 2))
        let timeSlot2 = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 1))
        
        let expectedIntersection: TimeSlot? = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 1), and: Date(timeIntervalSinceReferenceDate: 1))
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
}
