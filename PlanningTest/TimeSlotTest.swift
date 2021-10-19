
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
}
