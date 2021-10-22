
import XCTest
@testable import Planning



class TimeSlotTest: XCTestCase {

    
    func test_init_withStartDateDuration_valid() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = 2
        
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertNotNil(timeSlot)
        XCTAssertEqual(timeSlot!.startDate, startDate)
        XCTAssertEqual(timeSlot!.duration, duration)
    }
    
    
    func test_init_withStartDateDuration_durationZero() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = 0
        
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertNil(timeSlot)
    }
    
    
    func test_init_withStartDateDuration_durationNegative() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = -2
        
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)
        
        XCTAssertNil(timeSlot)
    }
    
    
    func test_init_betweenAnd_valid() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = 2
        let endDate = startDate.addingTimeInterval(duration)
        
        let timeSlot = TimeSlot(between: startDate, and: endDate)
        
        XCTAssertNotNil(timeSlot)
        XCTAssertEqual(timeSlot!.startDate, startDate)
        XCTAssertEqual(timeSlot!.duration, duration)
        XCTAssertEqual(timeSlot!.endDate, endDate)
    }
    
    
    func test_init_betweenAnd_endDatePriorToStartDate() {
        
        let startDate: Date = .referenceDate + 2.hours
        let endDate: Date = .referenceDate + 1.hours
        
        let timeSlot = TimeSlot(between: startDate, and: endDate)
        
        XCTAssertNil(timeSlot)
    }
    
    
    func test_init_betweenAnd_endDateEqualToStartDate() {
        
        let startDate: Date = .referenceDate
        let endDate: Date = .referenceDate
        
        let timeSlot = TimeSlot(between: startDate, and: endDate)
        
        XCTAssertNil(timeSlot)
    }
    
    
    func test_endDate() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = 2
        let timeSlot = TimeSlot(withStartDate: startDate, duration: duration)!
        
        XCTAssertEqual(timeSlot.endDate, startDate.addingTimeInterval(duration))
    }
    
    
    func test_equatable() {
        
        let startDate: Date = .referenceDate
        let duration: TimeInterval = 2
        
        let timeSlot1 = TimeSlot(withStartDate: startDate, duration: duration)!
        var timeSlot2 = TimeSlot(withStartDate: startDate, duration: duration)!
        
        XCTAssertEqual(timeSlot1, timeSlot2)
        
        timeSlot2.duration = 3
        
        XCTAssertNotEqual(timeSlot1, timeSlot2)
    }
    
    
    func test_intersection_noIntersection_apart() {
        
        let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)!
        let timeSlot2 = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 3.hours)!
        
        let expectedIntersection: TimeSlot? = nil
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_noIntersection_adjacent() {
        
        let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!
        let timeSlot2 = TimeSlot(between: .referenceDate + 2.hours, and: .referenceDate + 4.hours)!
        
        let expectedIntersection: TimeSlot? = nil
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_oneContainsTheOther() {
        
        let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 3.hours)!
        let timeSlot2 = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 2.hours)!
        
        let expectedIntersection: TimeSlot? = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 2.hours)!
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
    
    
    func test_intersection_partialIntersection() {
        
        let timeSlot1 = TimeSlot(between: .referenceDate, and: .referenceDate + 2.hours)!
        let timeSlot2 = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 3.hours)!
        
        let expectedIntersection: TimeSlot? = TimeSlot(between: .referenceDate + 1.hours, and: .referenceDate + 2.hours)!
        
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot1, and: timeSlot2), expectedIntersection)
        XCTAssertEqual(TimeSlot.intersection(between: timeSlot2, and: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersection(with: timeSlot2), expectedIntersection)
        XCTAssertEqual(timeSlot2.intersection(with: timeSlot1), expectedIntersection)
        
        XCTAssertEqual(timeSlot1.intersects(with: timeSlot2), expectedIntersection != nil)
        XCTAssertEqual(timeSlot2.intersects(with: timeSlot1), expectedIntersection != nil)
    }
}
