
import XCTest
@testable import Planning



class datesTest: XCTestCase {

    
    func test_referenceDate() {
        
        XCTAssertEqual(Date.referenceDate, Date(timeIntervalSinceReferenceDate: 0))
    }
}
