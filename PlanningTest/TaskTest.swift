
import XCTest
@testable import Planning



class TaskTest: XCTestCase {

    
    func test_init_withName() {
        
        let taskName = "task"
        let task = Task(withName: taskName)
        
        XCTAssertEqual(task.name, taskName)
        XCTAssertNil(task.referenceDuration)
    }
    
    
    func test_init_withNameReferenceDuration() {
        
        let taskName = "task"
        let referenceDuration = 3.hours
        let task = Task(withName: taskName, referenceDuration: referenceDuration)
        
        XCTAssertEqual(task.name, taskName)
        XCTAssertEqual(task.referenceDuration, referenceDuration)
    }
    
    
    func test_equatable() {
        
        let task1 = Task(withName: "t1")
        let task2 = Task(withName: "t2")
        let task3 = task1
        
        XCTAssertNotEqual(task1, task2)
        XCTAssertEqual(task1, task3)
    }
}
