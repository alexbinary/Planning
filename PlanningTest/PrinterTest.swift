
import XCTest
@testable import Planning



class PrinterTest: XCTestCase {

    
    func test_makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot() {
        
        let timeSlot = TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)!
        
        let printer = Printer()
        let model = printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(timeSlot)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "(Empty)")
        XCTAssertEqual(model.title, "Empty")
        XCTAssertEqual(model.subtitle, nil)
        XCTAssertEqual(model.extra, nil)
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelRepresenting() {
        
        let task = Task(withName: "t1", referenceDuration: 30.minutes)
        let timeSlot = TimeSlot(between: .referenceDate, and: .referenceDate + 1.hours)!
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        
        let printer = Printer()
        let model = printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "\(scheduling.id)")
        XCTAssertEqual(model.title, "\(task.id)")
        XCTAssertEqual(model.subtitle, "\(task.name)")
        XCTAssertEqual(model.extra, "Feedback: \(scheduling.feedback?.description ?? "-")")
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresenting_continuous() {
        
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 4.hours, duration: 2.hours)!)
        let scheduling3 = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 6.hours, duration: 2.hours)!)
        
        let printer = Printer()
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling2),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling3),
        ])
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresenting_holes() {
        
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate +  2.hours, duration: 2.hours)!)
        let scheduling2 = planning.schedule(Task(withName: "t2", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate +  6.hours, duration: 2.hours)!)
        let scheduling3 = planning.schedule(Task(withName: "t3", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 10.hours, duration: 2.hours)!)
        
        let printer = Printer()
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: scheduling2.timeSlot.startDate)!),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling2),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling2.timeSlot.endDate, and: scheduling3.timeSlot.startDate)!),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling3),
        ])
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresentingRestrictedTo_emptyStart() {
        
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: .referenceDate + 1.hours, duration: 3.hours)!
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning, restrictedTo: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: scheduling1.timeSlot.startDate)!),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
        ])
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresentingRestrictedTo_emptyEnd() {
        
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: .referenceDate + 3.hours, duration: 2.hours)!
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning, restrictedTo: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: timeSlot.endDate)!),
        ])
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresentingRestrictedTo_emptyStartAndEnd() {
        
        var planning = Planning(taskSchedulings: [])
        
        let scheduling1 = planning.schedule(Task(withName: "t1", referenceDuration: 30.minutes), on: TimeSlot(withStartDate: .referenceDate + 2.hours, duration: 2.hours)!)
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: .referenceDate + 1.hours, duration: 5.hours)!
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning, restrictedTo: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: scheduling1.timeSlot.startDate)!),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: timeSlot.endDate)!),
        ])
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelsRepresentingRestrictedTo_noTaskSchedulings() {
        
        let planning = Planning(taskSchedulings: [])
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: .referenceDate + 1.hours, duration: 5.hours)!
        let models = printer.makeAnnotatedTimeSlotPrintModels(representing: planning, restrictedTo: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: timeSlot.endDate)!),
        ])
    }
}
