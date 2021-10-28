
import XCTest
@testable import Planning



class Planning_scheduleTasksOnUsing_Test: XCTestCase {

    
    func test_scheduleTasksOnUsing_backlogBiggerThanSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        let task1 = Task(withName: "task1", referenceDuration: 10.minutes)
        let task2 = Task(withName: "task2", referenceDuration: 20.minutes)
        let task3 = Task(withName: "task3", referenceDuration: 30.minutes)
        
        _ = backlog.add(task1)
        _ = backlog.add(task2)
        _ = backlog.add(task3)

        planning.scheduleTasks(on: TimeSlot(
                                between: .referenceDate,
                                    and: .referenceDate + 30.minutes
        )!, using: backlog)

        // Expected result :
        //
        // T + 0        - task1
        // T + 10 min   - task2
        // T + 30 min
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 2)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate,
                            and: .referenceDate + 10.minutes
        ))

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 10.minutes,
                            and: .referenceDate + 30.minutes
        ))
    }
    
    
    func test_scheduleTasksOnUsing_backlogSmallerThanSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        let task1 = Task(withName: "task1", referenceDuration: 10.minutes)
        let task2 = Task(withName: "task2", referenceDuration: 20.minutes)
        let task3 = Task(withName: "task3", referenceDuration: 30.minutes)
        
        _ = backlog.add(task1)
        _ = backlog.add(task2)
        _ = backlog.add(task3)

        planning.scheduleTasks(on: TimeSlot(
                                between: .referenceDate,
                                    and: .referenceDate + 70.minutes
        )!, using: backlog)

        // Expected result :
        //
        // T + 0        - task1
        // T + 10 min   - task2
        // T + 30 min   - task3
        // T + 60 min   - task1
        // T + 70 min
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 4)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, task1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate,
                            and: .referenceDate + 10.minutes
        ))

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, task2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 10.minutes,
                            and: .referenceDate + 30.minutes
        ))

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].task, task3)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].timeSlot, TimeSlot(
                        between: .referenceDate + 30.minutes,
                            and: .referenceDate + 60.minutes
        ))

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[3].task, task1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[3].timeSlot, TimeSlot(
                        between: .referenceDate + 60.minutes,
                            and: .referenceDate + 70.minutes
        ))
    }
    
    
    func test_scheduleTasksOnUsing_taskScheduledAfterSlot() {
 
        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])
        
        // manually scheduled tasks

        let preScheduledTask1 = Task(withName: "preScheduledTask1")
        
        planning.schedule(preScheduledTask1, on: TimeSlot(
                            between: .referenceDate + 1.hours,
                                and: .referenceDate + 1.hours + 10.minutes
        )!)
        
        // auto filling from backlog
        
        let backlogTask1 = Task(withName: "backlogTask1", referenceDuration: 10.minutes)
        let backlogTask2 = Task(withName: "backlogTask2", referenceDuration: 20.minutes)
        
        _ = backlog.add(backlogTask1)
        _ = backlog.add(backlogTask2)
        
        planning.scheduleTasks(on: TimeSlot(
            between: .referenceDate,
                and: .referenceDate + 30.minutes
        )!, using: backlog)
        
        // Expected result :
        //
        // T + 0        - backlogTask1
        // T + 10 min   - backlogTask2
        // T + 30 min
        // T + 60 min   - pre scheduled task 1
        // T + 70 min
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 3)
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, backlogTask1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate,
                            and: .referenceDate + 10.minutes
        ))
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, backlogTask2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 10.minutes,
                            and: .referenceDate + 30.minutes
        ))
        
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].task, preScheduledTask1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].timeSlot, TimeSlot(
                        between: .referenceDate + 1.hours,
                            and: .referenceDate + 1.hours + 10.minutes
        ))
    }
    
    
    func test_scheduleTasksOnUsing_tasksScheduledInsideSlot() {

        var planning = Planning(taskSchedulings: [])
        var backlog = Backlog(tasks: [])

        // manually scheduled tasks

        let preScheduledTask1 = Task(withName: "preScheduledTask1")
        let preScheduledTask2 = Task(withName: "preScheduledTask2")

        planning.schedule(preScheduledTask1, on: TimeSlot(
                                between: .referenceDate + 25.minutes,
                                    and: .referenceDate + 35.minutes
        )!)
        planning.schedule(preScheduledTask2, on: TimeSlot(
                                between: .referenceDate + 35.minutes,
                                    and: .referenceDate + 45.minutes
        )!)

        // auto filling from backlog

        let backlogTask1 = Task(withName: "backlogTask1", referenceDuration: 10.minutes)
        let backlogTask2 = Task(withName: "backlogTask2", referenceDuration: 20.minutes)
        let backlogTask3 = Task(withName: "backlogTask3", referenceDuration: 30.minutes)

        _ = backlog.add(backlogTask1)
        _ = backlog.add(backlogTask2)
        _ = backlog.add(backlogTask3)

        planning.scheduleTasks(on: TimeSlot(
            between: .referenceDate + 0.minutes,
            and: .referenceDate + 95.minutes
        )!, using: backlog)

        // Expected result :
        //
        // T + 0        - backlogTask1
        // T + 10 min
        // T + 25 min   - pre scheduled task 1
        // T + 35 min   - pre scheduled task 2
        // T + 45 min   - backlogTask2
        // T + 65 min   - backlogTask3
        // T + 95 min

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate.count, 5)

        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].task, backlogTask1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[0].timeSlot, TimeSlot(
                        between: .referenceDate + 0.minutes,
                            and: .referenceDate + 10.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].task, preScheduledTask1)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[1].timeSlot, TimeSlot(
                        between: .referenceDate + 25.minutes,
                            and: .referenceDate + 35.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].task, preScheduledTask2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[2].timeSlot, TimeSlot(
                        between: .referenceDate + 35.minutes,
                            and: .referenceDate + 45.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[3].task, backlogTask2)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[3].timeSlot, TimeSlot(
                        between: .referenceDate + 45.minutes,
                            and: .referenceDate + 65.minutes
        ))
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[4].task, backlogTask3)
        XCTAssertEqual(planning.taskSchedulings.sortedByStartDate[4].timeSlot, TimeSlot(
                        between: .referenceDate + 65.minutes,
                            and: .referenceDate + 95.minutes
        ))
    }
}
