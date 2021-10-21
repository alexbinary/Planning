
import XCTest
@testable import Planning



class PrinterTest: XCTestCase {

    
    func test_makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot() {
        
        let timeSlot = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
        
        let printer = Printer()
        let model = printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(timeSlot)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "(Empty)")
        XCTAssertEqual(model.title, "Empty")
        XCTAssertEqual(model.subtitle, nil)
        XCTAssertEqual(model.extra, nil)
    }
    
    
    func test_makeAnnotatedTimeSlotPrintModelRepresenting() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
        let scheduling = TaskScheduling(scheduling: task, on: timeSlot)
        
        let printer = Printer()
        let model = printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "\(scheduling.id)")
        XCTAssertEqual(model.title, "\(task.id)")
        XCTAssertEqual(model.subtitle, "\(task.name)")
        XCTAssertEqual(model.extra, "Feedback: \(scheduling.feedback?.description ?? "-")")
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFrom_continuous() {
        
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 6), duration: 2))
        
        let printer = Printer()
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling2),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling3),
        ])
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFrom_holes() {
        
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate:  2), duration: 2))
        let scheduling2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate:  6), duration: 2))
        let scheduling3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 10), duration: 2))
        
        let printer = Printer()
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: scheduling2.timeSlot.startDate)),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling2),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling2.timeSlot.endDate, and: scheduling3.timeSlot.startDate)),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling3),
        ])
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFromOn_emptyStart() {
        
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 3)
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: scheduling1.timeSlot.startDate)),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
        ])
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFromOn_emptyEnd() {
        
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 3), duration: 2)
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: timeSlot.endDate)),
        ])
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFromOn_emptyStartAndEnd() {
        
        var dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let scheduling1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 5)
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: scheduling1.timeSlot.startDate)),
            printer.makeAnnotatedTimeSlotPrintModel(representing: scheduling1),
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: scheduling1.timeSlot.endDate, and: timeSlot.endDate)),
        ])
    }
    
    
    func test_annotatedTimeSlotPrintModelsForPlanningFromOn_noTaskSchedulings() {
        
        let dataModel = DataModel(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 5)
        let models = printer.annotatedTimeSlotPrintModelsForPlanning(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeAnnotatedTimeSlotPrintModelRepresentingEmptyTimeSlot(TimeSlot(between: timeSlot.startDate, and: timeSlot.endDate)),
        ])
    }
}
