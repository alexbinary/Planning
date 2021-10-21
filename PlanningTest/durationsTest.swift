
import XCTest
@testable import Planning



class durationsTest: XCTestCase {

    
    func test_and() {
        
        XCTAssertEqual(TimeInterval(2).and(TimeInterval(3)), TimeInterval(5))
    }
    
    
    func test_extension_Int_seconds() {
        
        XCTAssertEqual(2.seconds, TimeInterval(2))
    }
    
    
    func test_extension_Int_minutes() {
        
        XCTAssertEqual(2.minutes, TimeInterval(2 * 60))
    }
    
    
    func test_extension_Int_hours() {
        
        XCTAssertEqual(2.hours, TimeInterval(2 * 60 * 60))
    }
}
